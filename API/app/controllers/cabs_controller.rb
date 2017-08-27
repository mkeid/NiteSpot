class CabsController < ApplicationController
  def index
  end

  def create
  end

  def list
    user_signed_in?
    @cabs = @user_self.school.services.cabs.order("services.name ASC")
    render :json => @cabs.map { |cab| { :cab_id => cab.id, :name => cab.name, :phone_number => cab.phone_number } }
  end

  def show
  end

  def update
  end

  def favorite
    user_signed_in?
    @user_self.favorite_cabs << Cab.find(params[:id])
  end

  def unfavorite
    user_signed_in?
    UserFavorite.find_by_cab_id_and_user_id(params[:id], @user_self.id).destroy
  end

end
