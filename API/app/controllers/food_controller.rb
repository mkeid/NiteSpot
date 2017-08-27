class FoodController < ApplicationController
  def index
    user_signed_in?
  end
end
