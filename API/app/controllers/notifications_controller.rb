class NotificationsController < ApplicationController
  # The following functions lists notifications belonging to the user.
  def list
    user_signed_in?
    if params.has_key? 'count'
      notifications = @user_self.notifications.order('notifications.created_at DESC').limit(@user_self.notifications.unchecked.count+params[:count])
    else
      notifications = @user_self.notifications.order('notifications.created_at DESC').limit(@user_self.notifications.unchecked.count+15)
    end
    render :json => notifications.map { |notification| { :id => notification.id,
                                                          :avatar_location => User.find(notification.from_user).avatar.url(:thumb),
                                                          :from_group => notification.from_group,
                                                          :from_party => notification.from_party,
                                                          :from_user => notification.from_user,
                                                          :message => notification.message,
                                                          :name => notification.from_group == nil ? render_name(notification.user_from) : notification.group_from.name,
                                                          :notification_type => notification.notification_type,
                                                          :shout_liked => notification.shout_liked,
                                                          :time => render_time(notification.created_at),
                                                          :unchecked => notification.unchecked,
                                                          :group_id => notification.group_id,
                                                          :place_id => notification.place_id,
                                                          :service_id => notification.service_id,
                                                          :user_id => notification.user_id } }
    check
  end

  # The following will display a single notification.
  def show
    user_signed_in?
    if Shout.find(params[:id]).user == @user_self
      render :json => { :id => notification.id,
                        :avatar_location => User.find(notification.from_user).avatar.url(:thumb),
                        :from_group => '',
                        :from_user => notification.from_user,
                        :message => notification.message,
                        :name => render_name(notification.user_from),
                        :notification_type => notification.notification_type,
                        :shout_liked => notification.shout_liked,
                        :time => render_time(notification.created_at),
                        :unchecked => notification.unchecked,
                        :group_id => '',
                        :place_id => notification.place_id,
                        :service_id => notification.service_id,
                        :user_id => notification.user_id }
    end
  end

  # The following will destroy a notification if it belongs to the user requesting its destruction.
  def destroy
    user_signed_in?
    shout = Shout.find(params[:id])
    shout.destroy if shout.user == @user_self
  end

  # The following function makes all the notifications belonging to a user checked in the database.
  def check
    user_signed_in?
    notifications = @user_self.notifications.unchecked
    notifications.each do |notification|
      notification.unchecked = false
      notification.save
    end
  end

end
