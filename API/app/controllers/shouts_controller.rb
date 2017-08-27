class ShoutsController < ApplicationController
=begin
  def create
    user_signed_in?
    if params.has_key?(:message) && params[:message] != '' && params.has_key?(:type) && params[:type] != nil
        shout = Shout.new
      if params[:type] == 'status'
        shout.shout_type = 'status'
      end
      shout.message = params[:message]
      shout.save
      @user_self.shouts << shout
      render :nothing => true
    end
  end
=end

  def likes
    user_signed_in?
    @shout = Shout.find(params[:id])
    if @shout.user_id != nil
      if (@shout.user.privacy == 'private' && !@shout.user.followers.include?(@user_self)) || (!@shout.user.schools.any? { |school| @user_self.schools.include?(school) })
        redirect_to '/me'
      end
    elsif @shout.group_id != nil
       if !@user_self.schools.include? @shout.group.school
         redirect_to '/me'
       end
    end
  end

  def list
    user_signed_in?
    feed_id_list = Array.new
    feed_id_list << @user_self.id
    @user_self.followed_users.each do |user|
      feed_id_list << user.id
    end

    group_id_list = Array.new
    @user_self.schools.primary.first.groups.each do |group|
      group_id_list << group.id
    end

    user_shouts = Shout.order('shouts.created_at DESC').all(:conditions => {:user_id => feed_id_list })
    group_shouts = Shout.order('shouts.created_at DESC').all(:conditions => {:group_id => group_id_list })
    shouts = user_shouts.zip(group_shouts).flatten.compact.sort { |a,b| b.created_at <=> a.created_at }

    render :json => shouts.map { |shout| {  :id => shout.id,
                                            :avatar_location => shout.user != nil ? shout.user.avatar.url(:thumb) : shout.group.avatar.url(:thumb),
                                            :group_id => shout.group_id,
                                            :liked_users => shout.liked_users.map { |user| user.id },
                                            :message => shout.message,
                                            :name => shout.user != nil ? render_name(shout.user) : render_name(shout.group),
                                            :place_id => shout.place_id,
                                            :profile_type => shout.user != nil ? render_class(shout.user) : render_class(shout.group),
                                            :service_id => shout.service_id,
                                            :time => render_time(shout.created_at),
                                            :type => shout.shout_type,
                                            :user_id => shout.user_id } }
  end

  def show
    user_signed_in?
    @shout = Shout.find(params[:id])
    if params[:preview]
      liked_users = @shout.liked_users.limit(5)
    else
      liked_users = @shout.liked_users
    end

    respond_to do |format|
      format.html
      format.json do
        render :json => { :avatar_location => @shout.user != nil ? @shout.user.avatar.url(:thumb) : @shout.group.avatar.url(:thumb),
                          :is_liked => @shout.liked_users.include?(@user_self),
                          :message => @shout.message,
                          :liked_users => liked_users.map { |user| {  :avatar_location => user.avatar.url(:thumb),
                                                                      :name => render_name(user),
                                                                      :time => render_time(ShoutLike.find_by_user_id(user.id).created_at),
                                                                      :user_id => user.id } },
                          :name => @shout.user != nil ? render_name(@shout.user) : render_name(@shout.group),
                          :time => render_time(@shout.created_at),
                          :time_full => render_time_full(@shout.created_at),
                          :type => @shout.shout_type,
                          :group_id => @shout.group_id,
                          :user_id => @shout.user_id }
      end
    end
  end

  def destroy
    user_signed_in?
    if Shout.find(params[:id]).user == @user_self
      Shout.destroy(params[:id])
      render :nothing => true
    end
  end

  def like
    user_signed_in?
    shout = Shout.find(params[:id])
    if (shout.user != nil && shout.user.privacy == 'public') || (shout.user != nil && shout.user.privacy == 'private' && shout.user.followed_users.include?(@user_self)) || (shout.user != nil && shout.user == @user_self) || (shout.group != nil && shout.group.school == @user_self.schools.primary.first)
      shout.liked_users << @user_self
      if shout.user != nil && shout.user != @user_self
        notification = Notification.new
        notification.from_user = @user_self.id
        notification.notification_type = 'shout_like'
        notification.shout_liked = shout.id
        notification.user_id = shout.user.id
        notification.save
      end
      render :nothing => true
    end
  end

  def unlike
    user_signed_in?
    ShoutLike.find_by_shout_id_and_user_id(params[:id],@user_self.id).destroy
    render :nothing => true
  end
end
