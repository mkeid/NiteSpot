class PartiesController < ApplicationController
  def index
    user_signed_in?
    @parties = Array.new
    parties_all = @user_self.schools.primary.parties.today
    parties_all.each do |party|
      if party.public || party.group.members.include?(@user_self) || party.invited_users.include?(@user_self)
        @parties << party
      end
    end
  end

  # Check the template, "groups/new_party"
  def new
  end

  # The following creates a new party.
  def create
    user_signed_in?
    group = Group.find(params[:group_id])

    # The following block makes sure the party time is a valid time.
    party_month = params[:party][:month].to_i
    if party_month > 12 || party_month < 1
      party_month = 1
    end
    party_day = params[:party][:day].to_i
    if party_day > 31 || party_day < 1
      party_day = 1
    end
    party_hour = params[:party][:hour].to_i
    if party_hour > 24 || party_hour < 1
      party_hour = 1
    end
    party_minute = params[:party][:minute].to_i
    if party_minute > 59 || party_minute < 0
      party_minute = 0
    end
    party_time = "#{Time.now.year}-#{party_month}-#{party_day} #{party_hour}:#{party_minute}:00".to_time(:utc)

    # The following makes sure a party cannot be thrown in the past.
    valid_time = true
    if party_time.month == Time.now.month
      if party_time.day < Time.now.day
        valid_time = false
      end
    end
    if party_time.year == Time.now.year && party_time.month < Time.now.month
      valid_time = false
    end
    if party_time.year < Time.now.year
      valid_time = false
    end

    # The following makes sure there aren't multiple parties on the same day.
    valid_party = true
    group.parties.each do |party|
      if party.time.strftime('%Y-%m-%d') ==  party_time.strftime('%Y-%m-%d')
        valid_party = false
      end
    end

    if group.admins.include?(@user_self) && params.has_key?(:party) && params[:party][:name] != '' && params[:party][:address] != '' && valid_party && valid_time
      party = Party.new(:address => params[:party][:address],
                        :description => params[:party][:description],
                        :name => params[:party][:name],
                        :public => params[:party][:public],
                        :time => party_time)
      party.save
      group.parties << party

      # The following creates a shout.
      shout = Shout.new
      party_when = 'today'
      if party_time.strftime('%Y-%m-%d') == Time.now.strftime('%Y-%m-%d') && party_time.hour > 18
        party_when = 'tonight'
      elsif party_time.strftime('%Y-%m') == Time.now.strftime('%Y-%m') && party_time.day == Time.now.day+1
        party_when = 'tomorrow'
      elsif party_time.strftime('%Y-%m-%d') != Time.now.strftime('%Y-%m-%d') && (party_time.strftime('%Y-%m') == Time.now.strftime('%Y-%m') && party_time.day != Time.now.day+1)
        party_when = "on #{party_time.strftime("%A %B %d#{render_num_ending(party_time.day)}")} at #{party_time.strftime('%h:%m %P')}"
      end
      shout.message = "is throwing a party #{party_when} at #{party_time.strftime('%I:%M %p')}."
      shout.shout_type = 'party_throw'
      shout.save
      group.shouts << shout
    end
  end

  def show
    user_signed_in?
    party = Party.find(params[:id])
    if party.public || party.group.members.include(@user_Self) || party.invited_users.include?(@user_self)
      respond_to do |format|
        format.html
        format.json do
          render :json => {:id => party.id,
                           :avatar_location => party.group.avatar.url(:large),
                           :group_id => party.group.id,
                           :group_name => party.group.name,
                           :name => party.name}
        end
      end
    end
  end

  def list
    user_signed_in?
    @parties = Array.new
    parties_all = @user_self.schools.primary.parties.today
    parties_all.each do |party|
      if party.public || party.group.members.include?(@user_self) || party.invited_users.include?(@user_self)
        @parties << party
      end
    end
    if @user_self.parties.today.count == 0 || params[:change] == 'true'
      respond_to do |format|
        format.html
        format.json do
          render :json => @parties.map { |party| {:id => party.id,
                                                  :address => party.address,
                                                  :avatar_location => party.group.avatar.url(:large),
                                                  :group_name => party.group.name,
                                                  :name => party.name,
                                                  :time => party.time.strftime('%I:%M %p'),
                                                  :type => 'vote'} }
        end
      end
    else
      respond_to do |format|
        format.html
        format.json do
          render :json => @parties.map { |party| {:party_id => party.id,
                                                  :address => party.address,
                                                  :avatar_location => party.group.avatar.url(:large),
                                                  :group_name => party.group.name,
                                                  :name => party.name,
                                                  :time => party.time.strftime('%I:%M %p'),
                                                  :type => 'result',

                                                  # The following renders the total number of all people going for each party.
                                                  :votes_female => party.users.female.count,
                                                  :votes_male => party.users.male.count,
                                                  :votes_total => party.users.female.count+party.users.male.count,

                                                  # The following renders the total number of all freshmen going for each party.
                                                  :votes_female_fr => party.users.female.fr.count,
                                                  :votes_male_fr => party.users.male.fr.count,
                                                  :votes_total_fr => party.users.female.fr.count+party.users.male.fr.count,

                                                  # The following renders the total number of all sophomores going for each party.
                                                  :votes_female_so => party.users.female.so.count,
                                                  :votes_male_so => party.users.male.so.count,
                                                  :votes_total_so => party.users.female.so.count+party.users.male.so.count,

                                                  # The following renders the total number of all juniors going for each party.
                                                  :votes_female_jr => party.users.female.jr.count,
                                                  :votes_male_jr => party.users.male.jr.count,
                                                  :votes_total_jr => party.users.female.jr.count+party.users.male.jr.count,

                                                  # The following renders the total number of all seniors going for each party.
                                                  :votes_female_sr => party.users.female.sr.count,
                                                  :votes_male_sr => party.users.male.sr.count,
                                                  :votes_total_sr => party.users.female.sr.count+party.users.male.sr.count}}
        end
      end
    end
  end

  def edit
    user_signed_in?
    check_privileges
    @party = Party.find(params[:id])
  end

  # This updates the party settings.
  def update
    user_signed_in?
    check_privileges
    party = Party.find(params[:id])

    party.address = params[:party][:address]
    party.description = params[:party][:description]
    party.name = params[:party][:name]
    party.public = params[:party][:public]

    # The following block makes sure the party time is a valid time.
    party_month = params[:party][:month].to_i
    if party_month > 12 || party_month < 1
      party_month = 1
    end
    party_day = params[:party][:day].to_i
    if party_day > 31 || party_day < 1
      party_day = 1
    end
    party_hour = params[:party][:hour].to_i
    if party_hour > 24 || party_hour < 1
      party_hour = 1
    end
    party_minute = params[:party][:minute].to_i
    if party_minute > 59 || party_minute < 0
      party_minute = 0
    end
    party.time = "#{Time.now.year}-#{party_month}-#{party_day} #{party_hour}:#{party_minute}:00".to_time

    party.save
  end

  # This destroys the party.
  def destroy
    user_signed_in?
    check_privileges
    @party.destroy
  end

  # This lists the attending users for a party.
  def attending_users
    user_signed_in?
    @party = Party.find(params[:id])
    # It will only create the list if the user has already voted on a party.
    if @user_self.parties.on_day(@party.time) != nil
      users = Array.new
      users_all = @party.users
      users_all.each do |user|
        # The list will only reveal the identity of a user if that user is either public or following the viewing user.
        if user.privacy == 'public' || user.followers.include?(@user_self)
          users << user
        else
          private_user = User.new
          private_user.name_first = 'Private'
          private_user.name_last = 'User'
          private_user.year = user.year
          users << private_user
        end
      end
      respond_to do |format|
        format.html
        format.json do
          render :json => users.map { |user| {:id => user.id,
                                              :avatar_location => user.avatar.url(:thumb),
                                              :name => render_name(user),
                                              :relation => find_relation_status(user),
                                              :year => user.year.capitalize}}
        end
      end
    else
      render :nothing => true
    end
  end

  # This is for the view for changing a party attendance.
  def change_attendance
    user_signed_in?
    redirect_to '/parties' if @user_self.schools.primary.parties.today.count == 0
    @parties = Array.new
    parties_all = @user_self.schools.primary.parties.today
    parties_all.each do |party|
      if party.public || party.group.members.include?(@user_self) || party.invited_users.include?(@user_self)
        @parties << party
      end
    end
  end

  def invite
    user_signed_in?
    check_privileges
    check_party_time
  end

  # This invites users to a party.
  def invite_users
    user_signed_in?
    check_privileges
    check_party_time
    invited_users = JSON.parse(params[:invited_users])
    invited_users.each do |user|
      if !party.invited_users.include?(user) && !party.users.include?(user)
        party.invited_users << user
        notification = Notification.new
        notification.from_group = @party.group.id
        notification.from_party = @party.id
        notification.notification_type = 'party_invite'
        notification.user_id = user.id
        notification.save
      end
    end
  end

  # This lists all the users that have been invited to a party.
  def invited_users
    user_signed_in?
    check_privileges
    users = Party.find(params[:id]).invited_users
    respond_to do |format|
      format.html
      format.json do
        render :json => users.map { |user| {:user_id => user.id,
                                            :avatar_location => user.avatar.url(:thumb),
                                            :name => render_name(user),
                                            :relation => find_relation_status(user),
                                            :year => user.year.capitalize }}
      end
    end
  end

  # This uninvites users from a party.
  def uninvite_users
    signed_in?
    check_privileges
    party = Party.find(params[:id])
    uninvited_users = params[:invited_users]
    uninvited_users.each do |user|
      if party.invited_users.include? user
        InvitedUser.find_by_party_id_and_user_id(party.id, user.id).destroy
      end
    end
    render :nothing => true
  end

  def vote
    user_signed_in?
    party = Party.find(params[:id])

    if party.time.year >= Time.now.utc.year && party.time.month >= Time.now.utc.month && ((party.time.day >= Time.now.utc.day && !@is_time) || (party.time.day+1 >= Time.now.utc.day && @is_time))
      # The following checks if the user has permission to go to the party.
      party_available = false
      if party.public || party.group.members.include?(@user_self) || party.invited_users.include?(@user_self)
        party_available = true
      end
      party_unique_time = true
      replacement_id = nil
      @user_self.parties.each do |user_party|
        if party.time.strftime('%Y-%m-%d') == user_party.time.strftime('%Y-%m-%d')
          party_unique_time = false
          replacement_id = user_party.id
        end
      end

      # If the user has not already voted on this party and the party is occurring on the same day it is being voted on, proceed with the vote.
      if !@user_self.parties.include?(party) && party_available && @user_self.schools.primary.parties.include?(party)
        # If the user is voting on a party that is on the same date as another party, the previous party attendance is destroyed. A user can only go to a single party per day.
        if !party_unique_time
          UserAttendance.find_by_party_id_and_user_id(replacement_id, @user_self.id).destroy
        end
        Shout.create(:shout_type => 'party_attendance', :referenced_party_id => party.id, :user_id => @user_self.id)
=begin
        if party.time.strftime('%Y-%m-%d') == Time.now.strftime('%Y-%m-%d')
          shout.message = "is attending #{party.group.name}'s party \"#{party.name}\" today at #{party.time.strftime('%I:%M %p')}."
        else
          shout.message = "is attending #{party.group.name}'s party \"#{party.name}\" on #{party.time.strftime('%d %b')} at #{party.time.strftime('%I:%M %p')}."
        end
=end
        UserAttendance.create(:party_id => party.id, :user_id => @user_self.id)
        render :nothing => true
      else
        render :nothing => true
      end
    end
  end

  def check_party_time
    if @party.time.year >= Time.now.utc.year && @party.time.month >= Time.now.utc.month && @party.time.day >= Time.now.utc.day
    else
      redirect_to "/groups/#{@party.group.id}"
    end
  end

  # This checks if the user has rights to make administrative decisions for the group.
  def check_privileges
    if Party.exists?(params[:id]) && Party.find(params[:id]).group.admins.include?(@user_self)
      @party = Party.find(params[:id])
    else
      redirect_to '/groups'
    end
  end
end