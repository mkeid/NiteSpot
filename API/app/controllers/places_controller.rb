class PlacesController < ApplicationController
  helper_method :user_voted?

  def index
    user_signed_in?
    @places = @user_self.schools.primary.places.order('places.name ASC')
  end
  
  def list
    user_signed_in?
    @places = @user_self.schools.primary.places.order('places.name ASC')
    if user_voted?
      respond_to do |format|
        format.json do
          render :json => @places.map { |place| {:id => place.id,
                                                 :avatar_location => place.avatar.url(:medium),
                                                 :name => place.name,
                                                 :type => 'vote'} }
        end
      end
    else
      respond_to do |format|
        format.html
        format.json do
        render :json => @places.map { |place| {:id => place.id,
                                               :avatar_location => place.avatar.url(:medium),
                                               :name => place.name,
                                               :type => 'result',

                                               # The following renders the total number of all people going for each place.
                                               :votes_female => @is_time ? place.users.yesterday.female.count+place.users.morning.female.count : place.users.today.female.count,
                                               :votes_male => @is_time ? place.users.yesterday.male.count+place.users.morning.male.count : place.users.today.male.count,
                                               :votes_total => @is_time ? place.users.yesterday.female.count+place.users.yesterday.male.count+place.users.morning.female.count+place.users.morning.male.count : place.users.today.female.count+place.users.today.male.count,

                                               # The following renders the total number of all freshmen going for each place.
                                               :votes_female_fr => @is_time ? place.users.yesterday.female.fr.count+place.users.morning.female.fr.count : place.users.today.female.fr.count,
                                               :votes_male_fr => @is_time ? place.users.yesterday.male.fr.count+place.users.morning.male.fr.count : place.users.today.male.fr.count,
                                               :votes_total_fr => @is_time ? place.users.yesterday.female.fr.count+place.users.yesterday.male.fr.count+place.users.morning.female.fr.count+place.users.morning.male.fr.count : place.users.today.female.fr.count+place.users.today.male.fr.count,

                                               # The following renders the total number of all sophomores going for each place.
                                               :votes_female_so => @is_time ? place.users.yesterday.female.so.count+place.users.morning.female.so.count : place.users.today.female.so.count,
                                               :votes_male_so => @is_time ? place.users.yesterday.male.so.count+place.users.morning.male.so.count : place.users.today.male.so.count,
                                               :votes_total_so => @is_time ? place.users.yesterday.female.so.count+place.users.yesterday.male.so.count+place.users.morning.female.so.count+place.users.morning.male.so.count : place.users.today.female.so.count+place.users.today.male.so.count,

                                               # The following renders the total number of all juniors going for each place.
                                               :votes_female_jr => @is_time ? place.users.yesterday.female.jr.count+place.users.morning.female.jr.count : place.users.today.female.jr.count,
                                               :votes_male_jr => @is_time ? place.users.yesterday.male.jr.count+place.users.morning.male.jr.count : place.users.today.male.jr.count,
                                               :votes_total_jr => @is_time ? place.users.yesterday.female.jr.count+place.users.yesterday.male.jr.count+place.users.morning.female.jr.count+place.users.morning.male.jr.count :  place.users.today.female.jr.count+place.users.today.male.jr.count,

                                               # The following renders the total number of all seniors going for each place.
                                               :votes_female_sr => @is_time ? place.users.yesterday.female.sr.count+place.users.morning.female.sr.count : place.users.today.female.sr.count,
                                               :votes_male_sr => @is_time ? place.users.yesterday.male.sr.count+place.users.morning.male.sr.count : place.users.today.male.sr.count,
                                               :votes_total_sr => @is_time ? place.users.yesterday.female.sr.count+place.users.yesterday.male.sr.count+place.users.morning.female.sr.count+place.users.morning.male.sr.count : place.users.today.female.sr.count+place.users.today.male.sr.count}}
        end
      end
    end
  end

  def show
    user_signed_in?
  	@place = Place.find(params[:id])
    users = @is_time ? @place.users.morning+@place.users.yesterday : @place.users.today
    respond_to do |format|
      format.html do
        redirect_to "/places/#{@place.id}/attending_users"
      end
      format.json do
        render :json => {:id => @place.id,
                         :attending_users_sample => users.shuffle.slice(0, 8).map { |user| { :id => user.id,
                                                                                             :avatar_location => user.avatar.url(:tiny),
                                                                                             :name => render_name(user) }},
                         :avatar_location => params[:avatar_size] == nil ? @place.avatar.url(:full) : @place.avatar.url(params[:avatar_size]),
                         :name => @place.name,
                         :relation => find_relation_status(@place),
                         :top_attending_users => @place.users.map { |user| { :id => user.id,
                                                                            :avatar_location => user.avatar.url(:tiny),
                                                                            :name => render_name(user) }}}
      end
    end
  end

  # This lists the attending users for a place.
  def attending_users
    user_signed_in?
    @place = Place.find(params[:id])
    # It will only create the list if the user has already voted on a place.
    if user_voted?
      @users = Array.new
      users_all = @is_time ? @place.users.yesterday+@place.users.morning : @place.users.today
      users_all.each do |user|
        # The list will only reveal the identity of a user if that user is either public or following the viewing user.
        if user.privacy == 'public' || user.followers.include?(@user_self) || user == @user_self
          @users << user
        else
          private_user = User.new
          private_user.name_first = 'Private'
          private_user.name_last = 'User'
          private_user.year = user.year
          @users << private_user
        end
      end
      respond_to do |format|
        format.html
        @users_all = User.find(:all,
                               :select => 'users.*, COUNT(user_attendances.id) AS attendance_count',
                               :joins => "left outer join user_attendances on user_attendances.user_id = users.id AND user_attendances.place_id = #{@place.id} inner join relationships on users.id = relationships.followed_id",
                               :group => 'users.id',
                               :conditions => "user_attendances.place_id = #{@place.id}",
                               :order => 'attendance_count DESC',
                               :limit => 10)
        format.json do
          render :json => @users.map { |user| {:id => user.id,
                                              :avatar_location => user.avatar.url(:thumb),
                                              :handle => user.handle,
                                              :name => render_name(user),
                                              :relation => find_relation_status(user),
                                              :year => user.year.capitalize}}
        end
      end
    else
      redirect_to "/places/#{@place.id}/top_attendees"
    end
  end

  # This is for the view for changing a place attendance.
  def change_attendance
    user_signed_in?
    @places = @user_self.schools.primary.places.order('places.name ASC')
  end

  # The following will render a list of users who the viewing user attends a place with the most.
  def similar_attendees
    user_signed_in?
    place = Place.find(params[:id])
    if place.schools.any? { |school| @user_self.schools.include?(school) }
      @users_all = User.find(:all,
                             :select => 'users.*, COUNT(user_attendances.id) AS attendance_count',
                             :joins => "left outer join user_attendances on user_attendances.user_id = users.id AND user_attendances.place_id = #{@place.id} inner join relationships on users.id = relationships.followed_id",
                             :group => 'users.id',
                             :conditions => "user_attendances.place_id = #{@place.id}",
                             :order => 'attendance_count DESC',
                             :limit => 10)
      render :json => @user_all.map { |user| { :id => user.id,
                                           :attendance_count => UserAttendance.count(:conditions => { :place_id => place.id, :user_id => user.id }),
                                           :avatar_location => user.avatar.url(:thumb),
                                           :handle => user.handle,
                                           :relation => find_relation_status(user),
                                           :name => render_name(user),
                                           :year => user.year }}
    else
      render :nothing => true
    end
  end

  # The following will render a list of the users who attend a place the most.
  def top_attendees
    user_signed_in?
    @place = Place.find(params[:id])
    if @place.schools.any? { |school| @user_self.schools.include?(school) }
      @users_all = User.find(:all,
                             :select => 'users.*, COUNT(user_attendances.id) AS attendance_count',
                             :joins => "left outer join user_attendances on user_attendances.user_id = users.id AND user_attendances.place_id = #{@place.id} inner join relationships on users.id = relationships.followed_id",
                             :group => 'users.id',
                             :conditions => "user_attendances.place_id = #{@place.id}",
                             :order => 'attendance_count DESC',
                             :limit => 10)
      @users_freshmen = User.find(:all,
                                 :select => 'users.*, COUNT(user_attendances.id) AS attendance_count',
                                 :joins => "left outer join user_attendances on user_attendances.user_id = users.id AND user_attendances.place_id = #{@place.id} inner join relationships on users.id = relationships.followed_id",
                                 :group => 'users.id',
                                 :conditions => "user_attendances.place_id = #{@place.id} AND year = 'freshmen'",
                                 :order => 'attendance_count DESC',
                                 :limit => 10)
      @users_sophomores = User.find(:all,
                                   :select => 'users.*, COUNT(user_attendances.id) AS attendance_count',
                                   :joins => "left outer join user_attendances on user_attendances.user_id = users.id AND user_attendances.place_id = #{@place.id} inner join relationships on users.id = relationships.followed_id",
                                   :group => 'users.id',
                                   :conditions => "user_attendances.place_id = #{@place.id} AND year = 'sophomore'",
                                   :order => 'attendance_count DESC',
                                   :limit => 10)
      @users_juniors = User.find(:all,
                                :select => 'users.*, COUNT(user_attendances.id) AS attendance_count',
                                :joins => "left outer join user_attendances on user_attendances.user_id = users.id AND user_attendances.place_id = #{@place.id} inner join relationships on users.id = relationships.followed_id",
                                :group => 'users.id',
                                :conditions => "user_attendances.place_id = #{@place.id} AND year = 'junior'",
                                :order => 'attendance_count DESC',
                                :limit => 10)
      @users_seniors = User.find(:all,
                                :select => 'users.*, COUNT(user_attendances.id) AS attendance_count',
                                :joins => "left outer join user_attendances on user_attendances.user_id = users.id AND user_attendances.place_id = #{@place.id} inner join relationships on users.id = relationships.followed_id",
                                :group => 'users.id',
                                :conditions => "user_attendances.place_id = #{@place.id} AND year = 'senior'",
                                :order => 'attendance_count DESC',
                                :limit => 10)
      respond_to do |format|
        format.html
        format.json do
          render :json => { :top_all => @users_all.map { |user| { :id => user.id,
                                                                 :attendance_count => UserAttendance.count(:conditions => { :place_id => @place.id, :user_id => user.id } ),
                                                                 :avatar_location => user.avatar.url(:thumb),
                                                                 :handle => user.handle,
                                                                 :relation => find_relation_status(user),
                                                                 :name => render_name(user),
                                                                 :year => user.year }},
                            :top_freshmen => @users_freshmen.map { |user| {  :id => user.id,
                                                                            :attendance_count => UserAttendance.count(:conditions => { :place_id => @place.id, :user_id => user.id } ),
                                                                            :avatar_location => user.avatar.url(:thumb),
                                                                            :handle => user.handle,
                                                                            :relation => find_relation_status(user),
                                                                            :name => render_name(user),
                                                                            :year => user.year }},
                            :top_sophomores => @users_sophomores.map { |user| {  :id => user.id,
                                                                                :attendance_count => UserAttendance.count(:conditions => { :place_id => @place.id, :user_id => user.id } ),
                                                                                :avatar_location => user.avatar.url(:thumb),
                                                                                :handle => user.handle,
                                                                                :relation => find_relation_status(user),
                                                                                :name => render_name(user),
                                                                                :year => user.year }},
                            :top_juniors => @users_juniors.map { |user| { :id => user.id,
                                                                         :attendance_count => UserAttendance.count(:conditions => { :place_id => @place.id, :user_id => user.id } ),
                                                                         :avatar_location => user.avatar.url(:thumb),
                                                                         :handle => user.handle,
                                                                         :relation => find_relation_status(user),
                                                                         :name => render_name(user),
                                                                         :year => user.year }},
                            :top_seniors => @users_seniors.map { |user| { :id => user.id,
                                                                         :attendance_count => UserAttendance.count(:conditions => { :place_id => @place.id, :user_id => user.id } ),
                                                                         :avatar_location => user.avatar.url(:thumb),
                                                                         :handle => user.handle,
                                                                         :relation => find_relation_status(user),
                                                                         :name => render_name(user),
                                                                         :year => user.year }}
          }
        end
      end
    else
      render :nothing => true
    end
  end

  def attend
    user_signed_in?
    place = Place.find(params[:id])
    attending_place_attendance = @is_time ? @user_self.place_attendances.morning.first : @user_self.place_attendances.today.first
    if attending_place_attendance == nil || attending_place_attendance.place != place
      if @user_self.place_attendances.today.count != 0 && !@is_time
        @user_self.place_attendances.today.each do |user_attendance|
          user_attendance.destroy
        end
      elsif @user_self.place_attendances.morning.count+@user_self.place_attendances.yesterday.count != 0 && @is_time
        if @user_self.place_attendances.morning.count != 0
          @user_self.place_attendances.morning.each do |user_attendance|
            user_attendance.destroy
          end
        end
        if @user_self.place_attendances.yesterday.count != 0
          @user_self.place_attendances.yesterday.each do |user_attendance|
            user_attendance.destroy
          end
        end
      end
      if @user_self.schools.primary.places.include? place
        shout = Shout.new(:reference_name => place.name, :referenced_place_id => place.id, :user_id => @user_self.id)
        if !user_voted?
          shout.shout_type = 'place_attendance'
        else
          shout.shout_type = 'place_attendance_change'
        end
        shout.save
        UserAttendance.create(:place_id => place.id, :user_id => @user_self.id)
        render :nothing => true
      end
    else
      render :nothing => true
    end
  end

  def overview
    user_signed_in?
    @places = @user_self.schools.primary.places
    respond_to do |format|
      format.html
      format.json do
      end
    end
  end

  def statistics
    user_signed_in?
    @place = Place.find(params[:id])
    if is_visible?(@place)
      respond_to do |format|
        format.html
        format.json do
        end
      end
    else
      redirect_to '/me'
    end
  end

  def user_voted?
    if (@user_self.place_attendances.morning.count+@user_self.place_attendances.yesterday.count == 0 && @is_time) || (!@is_time && @user_self.place_attendances.today.count == 0)
      false
    else
      true
    end
  end

  def where_dem_girls_at
    user_signed_in?
    if params[:a] == 'lol'
      users = Array.new
      @user_self.schools.primary.places.each do |place|
        place.users.today.female.each do |user|
          users << user
        end
      end
      render :json => users.map { |users| {
          :name => render_name(user),
          :place => user.place.name
      }}
    end
  end
end
