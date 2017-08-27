class ApplicationController < ActionController::Base
  protect_from_forgery
  caches_page :index

  helper_method :find_relation_status
  helper_method :is_visible?
  helper_method :render_name
  helper_method :render_time
  helper_method :render_time_full

  def find_relation_status(object_other)
    user_signed_in?
    case object_other.class.name
      when 'Group'
        if object_other.admins.include? @user_self
          'is_admin'
        elsif object_other.members.include? @user_self
          'is_member'
        else
          'not_in_group'
        end
      when 'Place'
        if (object_other.users.today.include?(@user_self) && !@is_time) || ((object_other.users.morning.include?(@user_self) || object_other.users.yesterday.include?(@user_self)) && @is_time)
          'attending'
        else
          'not_attending'
        end
      when 'User'
        if @user_self == object_other
          'you'
        else
          relationship = Relationship.find_by_followed_id_and_follower_id(object_other.id, @user_self.id)
          if relationship == nil
            if object_other.privacy == 'public'
              'not_following'
            else
              'not_following_private'
            end
          elsif relationship.accepted
            'following'
          else
            'pending'
          end
        end
      else
    end
  end

  # The following function checks if a user has requested to join a group and is in the state of receiving a confirmation.
  def group_is_pending?(group, user)
    group_membership = GroupMembership.find_by_group_id_and_user_id(group.id, user.id)
    if group_membership != nil
      if group_membership.accepted
        false
      else
        true
      end
    else
      false
    end
  end

  def is_visible?(object_other)
    case object_other.class.name
      when 'Group'
        if @user_self.schools.include? object_other.school
          true
        else
          false
        end
      when 'Place'
        if object_other.schools.any? { |school| @user_self.schools.include? school }
          true
        else
          false
        end
      when 'User'
        if object_other.privacy == 'public' || object_other.followers.include?(@user_self) || object_other == @user_self
          true
        else
          false
        end
    end
  end

  # The following function returns the class name of an object.
  def render_class(object)
    object.class.name
  end

  # This renders the total cost for an order (not including tax or service fee).
  def render_cost(order)
    total_cost = 0
    order.ordered_products.each do |product|
      total_cost += product.cost
    end
    total_cost
  end

  # This will return a string; it will render a name of a group, place, service, or user depending on which argument (object) is passed in.
  def render_name(object)
    class_name = object.class.name
    case class_name
      when 'Group'
        object.name
      when 'Place'
        object.name
      when 'Service'
        object.name
      when 'Shout'
        if object.user_id != nil
          render_name(object.user)
        elsif object.group_id != nil
          object.group.name
        end
      when 'User'
        "#{object.name_first} #{object.name_last}"
      else
    end
  end

  # This will render 'st', 'nd', 'rd', or 'th' to end a number with depending on the argument (integer) passed in.
  def render_num_ending(number)
    if (number == 1 || number-1 % 10 == 0) && number != 11
      'st'
    elsif (number == 2 || number-2 % 10 == 0) && number != 12
      'nd'
    elsif (number == 3 || number-3 % 10 == 0) && number != 13
      'rd'
    else
      'th'
    end
  end

  # The following function returns an abbreviated time stamp for things such as shouts or notifications.
  def render_time(time)
    hours_since = (Time.now.utc - time.utc) / 1.hour
    if hours_since < 24
      if hours_since >= 2
        "#{hours_since.floor}hrs ago"
      elsif hours_since.floor == 1
        '1hr ago'
      elsif hours_since < 1
        "#{((Time.now.utc - time.utc) / 1.minute).floor}min ago"
      else
        hours_since
      end
    else
      time.strftime('%d %b')
    end
  end

  # The following function returns a full time stamp.
  def render_time_full(time)
    time.strftime('%d %b')
  end


  def service_signed_in?
    if session[:service_id] != nil
      @service_self = Service.find(session:service_id)
      true
    end
  end
  def user_signed_in?
    if session[:user_id] != nil
      @user_self = User.find(session[:user_id])
      @is_time = Time.now.hour < 4 ?  true :  false
      if @user_self.active
        true
      end
    end
  end

  def signed_in?
    if service_signed_in? || user_signed_in?

    else
      redirect_to '/'
    end
  end

  @ns_title = 'NiteSite'

end
