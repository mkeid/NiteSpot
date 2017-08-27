class GroupsController < ApplicationController
  def index
    user_signed_in?
    @groups = @user_self.groups
  end

  def new
    user_signed_in?
  end

  def create
    user_signed_in?
    if params.has_key?(:group)
      group = Group.new
      group.name = params[:group][:name]
      group.group_type = params[:group][:group_type]
      group.public = params[:group][:public]
      group.avatar = params[:group][:avatar]
      group.save
      @user_self.schools.primary.groups << group

      # This puts the new group into the school belonging to the creating user.
      membership = GroupMembership.new
      membership.user_id = @user_self.id
      membership.is_admin = true
      membership.group_id = group.id
      membership.save

      # The following creates a new directory for the group.
      require 'fileutils'
      FileUtils.mkdir_p("#{Rails.public_path}/groups/#{group.id}")

      # On completion, you will be redirected back to the groups page.
      redirect_to '/groups'
    end
  end

  def list
    user_signed_in?
    @groups = @user_self.groups
    render :json => @groups.map { |group| { :avatar_location => group.avatar.url('large'),
                                            :group_id => group.id,
                                            :name => group.name,
                                            :type => group.group_type } }
  end

  def show
    user_signed_in?
    if Group.exists?(params[:id])
      @group = Group.find(params[:id])
      respond_to do |format|
        format.html do
          redirect_to "/groups/#{@group.id}/members"
        end
        format.json do
          render :json => { :avatar_location => params[:avatar_size] == nil ? @group.avatar.url(:full) : @group.avatar.url(params[:avatar_size]),
                            :count_admins => @group.admins.count,
                            :count_members => @group.members.count,
                            :count_parties => @group.parties.relevant.count,
                            :count_requests => @group.requests.count,
                            :id => @group.id,
                            :is_admin => @group.admins.include?(@user_self),
                            :is_member => @group.members.include?(@user_self),
                            :is_pending => group_is_pending?(@group, @user_self),
                            :name => @group.name,
                            :public => @group.public,
                            :type => @group.group_type }
        end
      end
    else
      redirect_to '/groups'
    end
  end

  def edit
    user_signed_in?
    check_privileges
  end

  def update
    user_signed_in?
    check_privileges
    @group.avatar = params[:group][:avatar] if params[:group][:avatar] != nil
    group_types = ['Fraternity', 'Off-Campus House', 'On-Campus House', 'Musical Group', 'Sorority', 'Sports Team', 'Other']
    @group.group_type = params[:group][:group_type] if params[:group][:group_type] != nil && group_types.include?(params[:group][:group_type])
    @group.name = params[:group][:name] if params[:group][:name] != nil
    @group.public = params[:group][:public] if params[:group][:public] != nil && (params[:group][:public] || !params[:group][:public])
    @group.save
    redirect_to "/groups/#{@group.id}/edit#success"
  end

  def destroy
    user_signed_in?
    group = Group.find(params[:id])
    if group.admins.include? @user_self
      Request.find_by_from_group(group.id).destroy
      group.destroy
    end
  end

  def admins
    user_signed_in?
    @group = Group.find(params[:id])
    respond_to do |format|
      format.html
      format.json do
        render :json => @group.admins.map { |admin| { :id => admin.id,
                                                     :avatar_location => admin.avatar.url('thumb'),
                                                     :handle => admin.handle,
                                                     :is_admin => true,
                                                     :is_following => @user_self.followed_users.include?(admin),
                                                     :name => "#{admin.name_first} #{admin.name_last}",
                                                     :relation => find_relation_status(admin),
                                                     :school => admin.schools.primary.name,
                                                     :year => admin.year.capitalize }}
      end
    end
  end

  # This adds a new admin to the group.
  def admin_add
    user_signed_in?
    check_privileges
    user = User.find(params[:user_id])
    if @group.members.include?(user) && !@group.admins.include?(user)
      membership = GroupMembership.find_by_group_id_and_user_id(@group.id, user.id)
      membership.is_admin = true
      membership.save
      render :nothing => true
    end
  end

  # This removes an admin from the group.
  def admin_remove
    signed_in?
    check_privileges
    user = User.find(params[:user_id])
    if @group.admins.include?(user)
      if user == @user_self && @group.admins.count == 1
      else
        membership = GroupMembership.find_by_group_id_and_user_id(@group.id, user.id)
        membership.is_admin = false
        membership.save
        render :nothing => true
      end
    end
  end

  def invite
    user_signed_in?
    check_privileges
  end

  def invite_users
    user_signed_in?
    check_privileges
    user_ids = JSON.parse(params[:user_ids])
    user_ids.each do |user_id|
      user = User.find(user_id.to_i)
      if Request.find_by_from_group_and_user_id(@group.id, user.id) == nil && @group.members.include?(user) == false
        request = Request.new
        request.from_group = @group.id
        request.request_type = 'group_invite'
        request.save
        user.requests << request
      end
    end
    render :nothing => true
  end

  def join
    user_signed_in?
    group = Group.find(params[:id])
    if @user_self.schools.include?(group.school) && !@user_self.groups.include?(group)
      if group.public
        group.members << @user_self
      else
        membership = GroupMembership.new
        membership.accepted = false
        membership.group = group
        membership.member = @user_self
        membership.save
        if Request.find_by_from_group_and_user_id(group.id, @user_self.id) != nil
          Request.find_by_from_group_and_user_id(group.id, @user_self.id).destroy
        end
        if Request.find_by_from_user_and_group_id(@user_self.id, group.id) == nil
          request = Request.new
          request.from_user = @user_self.id
          request.request_type = 'group_join'
          request.save
          group.requests << request
        end
      end
      render :nothing => true
    end
  end

  def leave
    user_signed_in?
    group = Group.find(params[:id])
    if group.admins.include?(@user_self) && group.admins.count == 1
      group.destroy
    else
      membership = GroupMembership.find_by_group_id_and_user_id(group.id, @user_self.id)
      membership.destroy
    end
    render :nothing => true
  end

  def members
    user_signed_in?
    @group = Group.find(params[:id])
    respond_to do |format|
      format.html
      format.json do
        render :json => group.members.map { |member| { :id => member.id,
                                                       :avatar_location => member.avatar.url('thumb'),
                                                       :handle => member.handle,
                                                       :is_admin => @group.admins.include?(member),
                                                       :is_following => @user_self.followed_users.include?(member),
                                                       :name => "#{member.name_first} #{member.name_last}",
                                                       :relation => find_relation_status(member),
                                                       :school => member.schools.primary.name,
                                                       :year => member.year.capitalize }}
      end
    end
  end

  def new_party
    user_signed_in?
    check_privileges
  end

  def parties
    user_signed_in?
    @group = Group.find(params[:id])
    @visible_parties = Array.new
    @group.parties.relevant.each do |party|
      if party.public || party.group.members.include?(@user_self) || party.invited_users.include?(@user_self)
        @visible_parties << party
      end
    end
    respond_to do |format|
      format.html
      format.json do
        render :json => @visible_parties.map { |party| { :id => party.id,
                                                        :address => party.address,
                                                        :avatar_location => party.group.avatar.url('thumb'),
                                                        :is_attending => party.users.include?(@user_self),
                                                        :name => party.name,
                                                        :time => party.time.strftime("%B %d#{render_num_ending(party.time.day)} @ %l:%M %p") }}
      end
    end
  end

  # This lists the possible users to invite to a group (user conditions include belonging in the inviter's followers list and not being already in the group).
  def possible_users_to_invite
    user_signed_in?
    check_privileges
    users = @user_self.followers.order('name_first ASC')
    render :json => users.map { |user| { :id => user.id,
                                         :available => !@group.members.include?(user) && !user.requests.include?(Request.find_by_from_group_and_user_id(@group.id, user.id)) ? true : false,
                                         :avatar_location => user.avatar.url(:thumb),
                                         :handle => user.handle,
                                         :relation => find_relation_status(user),
                                         :name => "#{user.name_first} #{user.name_last}",
                                         :school => user.schools.primary.name,
                                         :year =>user.year.capitalize } }
  end

  def user_remove
    signed_in?
    check_privileges
    user = User.find(params[:user_id])
    if @group.members.include?(user) && user != @user_self
      GroupMembership.find_by_group_id_and_user_id(@group.id, user.id).destroy
      render :nothing => true
    end
  end

  # This lists the group's requests.
  def requests
    user_signed_in?
    check_privileges
    if @group.admins.include? @user_self
      @requests = @group.requests
      render :json => @requests.map { |request|  {  :avatar_location => request.from_user != nil ? User.find(request.from_user).avatar.url(:thumb) : Group.find(request.from_group).avatar.url(:thumb),
                                                    :from_group => request.from_group,
                                                    :from_user => request.from_user,
                                                    :id => request.id,
                                                    :name => request.from_user != nil ? render_name(User.find(request.from_user)) : Group.find(request.from_group).name,
                                                    :request_type => request.request_type,
                                                    :user_id => request.user_id } }
    end
  end

  # The following will render a list of the users who attend this group's parties the most.
  def top_partiers
    user_signed_in?
    @group = Group.find(params[:id])
    party_ids = Array.new
    @group.parties.each do |party|
      party_ids << party.id
    end
    if @user_self.schools.include? @group.school
      @users = @user_self.schools.primary.users(:select => 'users.*, COUNT(party_attendances.id) AS attendance_count',
                                                     :joins => :party_attendances,
                                                     :group => 'party_attendances.id',
                                                     :conditions => ['party_attendances.party_id = ?', party_ids],
                                                     :order => 'attendance_count DESC').limit(10)

      respond_to do |format|
        format.html
        format.json do
          render :json => @users.map { |user| { :id => user.id,
                                               :attendance_count => UserAttendance.count(:conditions => { :party_id => party_ids, :user_id => user.id }),
                                               :avatar_location => user.avatar.url(:thumb),
                                               :handle => user.handle,
                                               :relation => find_relation_status(user),
                                               :name => render_name(user),
                                               :year => user.year }}
        end
      end
    else
      render :nothing => true
    end
  end

  def statistics
    user_signed_in?
    @group = Group.find(params[:id])
    is_visible?(@group)
    respond_to do |format|
      format.html
      format.json do

      end
    end
  end

  # This checks if the user has rights to make administrative decisions for the group.
  def check_privileges
    if Group.exists?(params[:id]) && Group.find(params[:id]).admins.include?(@user_self)
      @group = Group.find(params[:id])
    else
      redirect_to '/groups'
    end
  end

end