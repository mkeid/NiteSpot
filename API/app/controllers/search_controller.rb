class SearchController < ApplicationController
  def index
  end

  def list
    user_signed_in?
    query = params[:query].downcase
    if query != nil && query != ''
      matched_results = Array.new
      @user_self.schools.primary.first.users.order('name_first asc').each do |result|
        if render_name(result).downcase.include? query
          matched_results << result
        end
      end
      @user_self.schools.primary.first.groups.order('name asc').each do |result|
        if render_name(result).downcase.include? query
          matched_results << result
        end
      end
=begin
      @user_self.school.primary.first.services.order('name asc').each do |result|
        if render_name(result).downcase.include? query
          matched_results << result
        end
      end
=end
      @user_self.schools.primary.first.places.order('name asc').each do |result|
        if render_name(result).downcase.include? query
          matched_results << result
        end
      end
      respond_to do |format|
        format.html
        format.json do
          render :json => matched_results.map { |result| { :avatar_location => result.avatar.url('thumb'),
                                                           :class => render_class(result),
                                                           :group_type => render_class(result) == 'Group' ?  result.group_type : nil,
                                                           :label => render_class(result) == 'Service' ?  result.label : nil,
                                                           :name => render_name(result),
                                                           :year =>  render_class(result) == 'User' ? result.year : nil,
                                                           :id => result.id } }
        end
      end
    else
      render :nothing => true
    end
  end

  # The following searches for groups only.
  def search_groups
    user_signed_in?
    query = params[:query].downcase.gsub('%20', '').gsub(' ', '')
    if query != nil && query != ''
      respond_to do |format|
        format.html
        format.json do
          render :json => Group.in_school(@user_self.schools.primary).search(query).all.map { |result| { :id => result.id,
                                                                                                         :name => render_name(result) } }
        end
      end
    end
  end

  # The following searches for places only.
  def search_places
    user_signed_in?
    query = params[:query].downcase.gsub('%20', '').gsub(' ', '')
    if query != nil && query != ''
      respond_to do |format|
        format.html
        format.json do
          render :json => Place.search(query).all.map { |result| { :id => result.id,
                                                                   :name => render_name(result) } }
        end
      end
    end
  end

  # The following searches for users only.
  def search_users
    user_signed_in?
    query = params[:query].downcase.gsub('%20', '').gsub(' ', '')
    if query != nil && query != ''
      respond_to do |format|
        format.html
        format.json do
          render :json => User.in_school(@user_self.schools.primary).search(query).all.map { |result| { :id => result.id,
                                                                                                        :name => render_name(result) } }
        end
      end
    end
  end

end
