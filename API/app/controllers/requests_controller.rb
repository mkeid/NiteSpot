class RequestsController < ApplicationController
  # The following simply requests all the requests belonging to a user.
  def list
    user_signed_in?
    render :json => @user_self.requests.map { |request|  {  :avatar_location => request.from_user != nil ? User.find(request.from_user).avatar.url(:thumb) : Group.find(request.from_group).avatar.url(:thumb),
                                                            :from_group => request.from_group,
                                                            :from_user => request.from_user,
                                                            :id => request.id,
                                                            :name => request.from_user != nil ? render_name(User.find(request.from_user)) : Group.find(request.from_group).name,
                                                            :request_type => request.request_type,
                                                            :user_id => request.user_id } }
  end

  def show
  end

  # The following function deletes a request after checking if it belongs to the appropriate user.
  def destroy
    user_signed_in?
    request = Request.find(params[:id])
    if @user_self.requests.include? request
      case request.request_type
        # If the request was a 'group_invite' type request it will delete the unaccepted membership from he database.
        when 'group_invite'
          request.destroy
          render :nothing => true
        when 'group_join'
          request.destroy
          render :nothing => true
        # If the request was a 'user follow' type request it will delete the unaccepted relationship from he database.
        when 'user_follow'
          relationship = Relationship.find_by_followed_id_and_follower_id(@user_self.id, request.from_user)
          relationship.destroy
          render :nothing => true

        else
      end
      request.destroy
    end
  end

  # The following function accepts the request and does what it was asking for.
  def accept
    user_signed_in?
    request = Request.find(params[:id])
    if @user_self.requests.include?(request) || request.group.admins.include?(@user_self)
      case request.request_type
        when 'user_follow'
          user_other = User.find(request.from_user)
          relationship = Relationship.find_by_followed_id_and_follower_id(@user_self.id, user_other.id)
          relationship.accepted = true
          relationship.save
          Notification.create(:from_user => @user_self.id, :notification_type => 'follow_accept', :user_id => user_other.id)
          request.destroy
          render :nothing => true
        when 'group_invite'
          group = Group.find(request.from_group)
          if !@user_self.groups.include?(group)
            group.members << @user_self
          end
          request.destroy
          render :nothing => true
        when 'group_join'
          group = request.group
          group.members << User.find(request.from_user)
          request.destroy
          render :nothing => true
        else

      end
    end
  end
end
