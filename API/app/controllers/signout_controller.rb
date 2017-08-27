class SignoutController < ApplicationController
  def index
  	session[:user_id] = nil
    redirect_to "/"
  end
end
