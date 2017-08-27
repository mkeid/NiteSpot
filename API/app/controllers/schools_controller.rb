class SchoolsController < ApplicationController
  def index

  end

  def show
    user_signed_in?
    check_privileges
    users = @school.users
    respond_to do |format|
      format.html
      format.json do
        render :json => { :avatar_location => @school.avatar.url(:large),

                          :count_groups => @school.groups.count,
                          :count_parties => @school.parties.count,
                          :count_places => @school.places.count,

                          :count_users => users.count,
                          :count_users_female => users.female.count,
                          :count_users_male => users.male.count,

                          :count_users_freshmen => users.fr.count,
                          :count_users_freshmen_female => users.fr.female.count,
                          :count_users_freshmen_male => users.fr.male.count,

                          :count_users_sophomores => users.so.count,
                          :count_users_sophomores_female => users.so.female.count,
                          :count_users_sophomores_male => users.so.male.count,

                          :count_users_juniors => users.jr.count,
                          :count_users_juniors_female => users.jr.female.count,
                          :count_users_juniors_male => users.jr.male.count,

                          :count_users_seniors => users.sr.count,
                          :count_users_seniors_female => users.sr.female.count,
                          :count_users_seniors_male => users.sr.male.count,

                          :name => @school.name }
      end
    end
  end

  def list

  end

  def most_active_users
    user_signed_in?
    check_privileges
    users = @school.users.joins(:user_attendances).order("COUNT(#{:user_attendances}.id)").limit(10)
    render :json => users.map { |user| { :id => user.id,
                                         :attendance_count => UserAttendance.count(:conditions => { :user_id => user.id }),
                                         :avatar_location => user.avatar.url(:thumb),
                                         :relation => find_relation_status(user),
                                         :name => render_name(user),
                                         :year => user.year }}
  end

  def most_active_users_parties
    user_signed_in?
    check_privileges
    users = @school.users.joins(:party_attendances).order("COUNT(#{:party_attendances}.id)").limit(10)
    render :json => users.map { |user| { :id => user.id,
                                         :attendance_count => UserAttendance.count(:conditions => { :user_id => user.id, :place_id => nil }),
                                         :avatar_location => user.avatar.url(:thumb),
                                         :relation => find_relation_status(user),
                                         :name => render_name(user),
                                         :year => user.year }}
  end

  def most_active_users_places
    user_signed_in?
    check_privileges
    users = @school.users.joins(:place_attendances).order("COUNT(#{:place_attendances}.id)").limit(10)
    render :json => users.map { |user| { :id => user.id,
                                         :attendance_count => UserAttendance.count(:conditions => { :user_id => user.id, :party_id => nil }),
                                         :avatar_location => user.avatar.url(:thumb),
                                         :relation => find_relation_status(user),
                                         :name => render_name(user),
                                         :year => user.year }}
  end

  def stats
    user_signed_in?
    check_privileges
    user_attendances = UserAttendance.in_school(@school)
    render :json => { :count_place_attendances => user_attendances.places.count }
  end

  def check_privileges
    @school = School.find_by_handle(params[:id])
    if !@user_self.schools.include?(@school)
      redirect_to "/schools/#{@user_self.schools.primary.first.handle}"
    end
  end
end
