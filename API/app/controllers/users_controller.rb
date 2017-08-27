class UsersController < ApplicationController
	def index
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html
      format.json  { render :json => @user }
    end
  end

  # The following creates a new user (through signing up).
	def create
	  new_email = params[:user][:email].downcase
	  gender = params[:user][:gender].downcase
	  name_first = params[:user][:name_first].capitalize
	  name_last = params[:user][:name_last].capitalize
	  password = params[:user][:password]
	  year = params[:user][:year]
	  
	  # The following block creates an array containing all the valid email extensions that a user can sign up with.
	  school_list = Array.new
	  schools = School.all
	  schools.each do |school|
	    school_list << school.email_extension
    end

    # The following "if" statement checks if the user email is a valid school email from the array.
    school_email = nil
    school_list.each do |email|
      if new_email.include? email
        school_email = email
      end
    end

    # If the user email is valid, proceed to creating a user.
	  if school_email != nil
	    # The following "if" statement checks if there is already an account signed up with that email.
      if User.find_by_email(new_email) != nil
        redirect_to '/signup?s=taken'
      else
        # If everything goes accordingly, the following block creates a new row in the database for the user.
        user = User.create(:activation_token => make_salt("#{new_email}#{Time.now}"),
                           :active => false,
                           :email => new_email,
                           :gender => gender,
                           :name_first => name_first,
                           :name_last => name_last,
                           :privacy => 'public',
                           :salt => make_salt(new_email),
                           :year => year)
        user.password = hash_with_salt(password, user.salt)
        user.handle = user.id
        user.save

        # The following creates a new directory for the user account.
        require 'fileutils'
        FileUtils.mkdir_p("#{Rails.public_path}/users/#{user.id}")

        # The following adds the user to a school.
        school = School.find_by_email_extension(school_email)
        NetworkRequest.create(:school_id => school.id, :user_id => user.id)
        #UserMailer.welcome_email(user, password).deliver
        redirect_to "/signup?s=success&email=#{user.email}"
      end
	  else
	    redirect_to '/signup?s=invalid_school'
	  end
  end

  # The following displays a user page. If another format such as JSON or XML is requested it will display the user's details.
  def show
    user_signed_in?
    @user = User.find(params[:id])
    if @user.followers.include? @user_self
      is_following = true
    else
      is_following = false
      relationship = Relationship.find_by_followed_id(@user.id)
      if relationship == nil
        pending = false
      else
        if relationship.accepted
          pending = false
        else
          pending = true
        end
      end
    end

    respond_to do |format|
      format.html do
         redirect_to "/users/#{@user.id}/feed"
      end
      format.json do
          render :json => {:avatar_location => params[:avatar_size] == nil ? @user.avatar.url(:full) : @user.avatar.url(params[:avatar_size]),
                           :is_following => is_following,
                           :following_count => @user.followed_users.count,
                           :following_sample => @user.followed_users.shuffle.slice(0, 8).map { |user| { :id => user.id,
                                                                                                        :avatar_location => user.avatar.url(:tiny),
                                                                                                        :name => render_name(user)}},
                           :follower_count => @user.followers.count,
                           :follower_sample => @user.followers.shuffle.slice(0, 8).map { |user| { :id => user.id,
                                                                                                  :avatar_location => user.avatar.url(:tiny),
                                                                                                  :name => render_name(user)}},
                           :gender => @user.gender,
                           :group_count => @user.groups.count,
                           :group_sample => @user.groups.shuffle.slice(0, 8).map { |group| { :id => group.id,
                                                                                             :avatar_location => group.avatar.url(:tiny),
                                                                                             :name => group.name}},
                           :handle => @user.handle,
                           :id => @user.id,
                           :is_self => @user == @user_self,
                           :name => "#{@user.name_first} #{@user.name_last}",
                           :num_notifications => @user.notifications.unchecked.count,
                           :num_requests => @user.requests.count,
                           :pending => pending,
                           :privacy => @user.privacy,
                           :relation => find_relation_status(@user),
                           :shout_count => @user.shouts.count,
                           :year => @user.year}
      end
    end
  end

  def edit

  end

  # The following updates the user's settings and avatar.
	def update
    user_signed_in?
	  # The following if statement checks what type of settings are being updated (file versus attribute).
	  if params.has_key?(:user)
      @user = User.find(params[:id])
      if @user == @user_self
        @user.avatar = params[:user][:avatar]
        @user.save
        redirect_to '/settings'
      end
    else
      @user = @user_self
      @user.name_first = params[:name_first]
      @user.name_last = params[:name_last]
      @user.gender = params[:gender]
      @user.privacy = params[:privacy]
      @user.year = params[:year]
      if params[:password1] != nil && params[:password2] != nil && params[:password3] != nil && params[:password1] != params[:password2] && params[:password2] == params[:password3] && User.hash_with_salt(params[:password1], @user.salt) == @user.password
        @user.salt = User.make_salt(@user.email)
      @user.password = User.hash_with_salt(params[:password3], @user.salt)
      end
      school = School.find_by_name(params[:school])
      if @user.schools.include? school
        @user.school_memberships.each do |school_membership|
          if school_membership.school_id != school.id
            school_membership.is_primary = false
            school_membership.save
          end
        end
        updated_membership = SchoolMembership.find_by_school_id_and_user_id(school.id, @user.id)
        updated_membership.is_primary = true
        updated_membership.save
      end
      @user.save
      session[:gender] = @user.gender
      session[:name_first] = @user.name_first
      session[:name_last] = @user.name_last
      session[:gender] = @user.gender
      session[:privacy] = @user.privacy
      session[:user_id] = @user.id
      session[:year] = @user.year
      render :nothing => true
	  end
  end

  def destroy

  end

  # The following activates a user through the randomly generated link sent to his or her school email address.
  def activate
    activation_token = params[:token]
    user = User.find_by_activation_token(activation_token)
    user.active = true
    user.save
    redirect_to '/signin?s=activated'
  end

  # The following shows the user's favorite cabs.
  def favorite_cabs
    user_signed_in?
    respond_to do |format|
      format.html
      format.json do
        render :json => @user_self.favorite_cabs.map { |cab| { :id => cab.id,
                                                               :name => cab.name,
                                                               :phone_number => cab.phone_number }}
      end
    end
  end

  # The following shows the user's favorite services.
  def favorite_services
    user_signed_in?
    respond_to do |format|
      format.html
      format.json do
        render :json => @user_self.favorite_services.map { |service| { :id => service.id,
                                                                       :name => service.name }}
      end
    end
  end

  # The following displays a user's shouts.
  def feed
    user_signed_in?
    @user = User.find(params[:id])
    if is_visible?(@user)
      @shouts = @user.shouts.reverse
      respond_to do |format|
        format.html
        format.json do
          render :json => @shouts.map { |shout| { :id => shout.id,
                                                  :avatar_location => shout.user.avatar.url(:thumb),
                                                  :liked_users => shout.liked_users.map { |user| user.id },
                                                  :message => shout.message,
                                                  :name => "#{shout.user.name_first} #{shout.user.name_last}",
                                                  :user_id => shout.user_id,
                                                  :user_handle => shout.user.handle,
                                                  :time => render_time(shout.created_at),
                                                  :type => shout.shout_type }}
        end
      end
    else
      redirect_to "/users/#{@user.id}/private"
    end
  end

  # This functions follows a user (or sends a follow request if the other user's account is private).
  def follow
    user_signed_in?
    user_follow = User.find(params[:id])
    if user_follow != @user_self && user_follow.schools.any? { |school| @user_self.schools.include?(school) } && user_follow.followers.include?(@user_self) == false
      if user_follow.privacy == 'public'
        @user_self.follow!(user_follow)
        notification = Notification.new
        notification.from_user = @user_self.id
        notification.notification_type = 'user_follow'
        notification.user_id = user_follow.id
        notification.save
        render :nothing => true
      elsif user_follow.privacy == 'private'
        @user_self.ask_to_follow(user_follow)
        if Request.find_by_from_user_and_user_id(@user_self.id, user_follow.id) == nil
          request = Request.new
          request.from_user = @user_self.id
          request.request_type = 'user_follow'
          request.save
          user_follow.requests << request
          render :nothing => true
        end
      end
    end
  end

  # This lists a user's followed users.
  def followed_users
    user_signed_in?
    @user = User.find(params[:id])
    if is_visible?(@user)
      @followed_users = @user.followed_users
      respond_to do |format|
        format.html
        format.json do
          render :json => @followed_users.map { |user| { :id => user.id,
                                                         :avatar_location => user.avatar.url(:thumb),
                                                         :handle => user.handle,
                                                         :name => "#{user.name_first} #{user.name_last}",
                                                         :relation => find_relation_status(user),
                                                         :school => user.schools.primary.name,
                                                         :year => user.year.capitalize } }
        end
      end
    else
      redirect_to "/users/#{@user.id}/private"
    end
  end

  # This lists a user's followers.
  def followers
    user_signed_in?
    @user = User.find(params[:id])
    if is_visible?(@user)
      @followers = @user.followers
      respond_to do |format|
        format.html
        format.json do
          render :json => @followers.map { |user| { :id => user.id,
                                                    :avatar_location => user.avatar.url(:thumb),
                                                    :handle => user.handle,
                                                    :relation => find_relation_status(user),
                                                    :name => "#{user.name_first} #{user.name_last}",
                                                    :school => user.schools.primary.name,
                                                    :year =>user.year.capitalize } }
        end
      end
    else
      redirect_to "/users/#{@user.id}/private"
    end
  end

  # This lists a user's groups.
  def groups
    user_signed_in?
    @user = User.find(params[:id])
    if is_visible?(@user)
      @groups = @user.groups
      respond_to do |format|
        format.html
        format.json do
          render :json => @groups.map { |group| { :id => group.id,
                                                  :avatar_location => group.avatar.url('large'),
                                                  :name => group.name,
                                                  :type => group.group_type } }
        end
      end
    else
      redirect_to "/users/#{@user.id}/private"
    end
  end

  # This functions checks if a user is following another user or not.
  def is_following?(user)
    user_signed_in?
    if @user_self.followed_users.include? user
      true
    else
      false
    end
  end

  def private
    user_signed_in?
    @user = User.find(params[:id])
    if is_visible?(@user)
      redirect_to "/users/#{@user.id}/feed"
    end
  end

  # This functions creates various statistics of that user.
  def statistics
    user_signed_in?
    @user = User.find(params[:id])
    if is_visible?(@user)
      respond_to do |format|
        format.html
        format.json do
          render :json => { :count_party_attendances => @user.party_attendances.count,
                            :count_place_attendances => @user.place_attendances.in_school(@user.schools.primary.first).count,
                            :place_attendances => @user.schools.primary.first.places.map { |place| { :count_attendance => UserAttendance.where(:place_id => place.id, :user_id => @user.id).count,
                                                                                                    :place_name => "#{place.name} (#{UserAttendance.where(:place_id => place.id, :user_id => @user.id).count})"  }
                            } }
        end
      end
    else
      redirect_to "/users/#{@use.id}/private"
    end
  end

  # This function unfollows another user
  def unfollow
    user_signed_in?
    @user_self = User.find(session[:user_id])
    user_unfollow = User.find(params[:id])
    @user_self.unfollow!(user_unfollow)
    render :nothing => true
  end

end