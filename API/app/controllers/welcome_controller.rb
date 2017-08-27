class WelcomeController < ApplicationController
  def index
    if session[:user_id] != nil
      redirect_to '/places'
    end
    if session[:service_id] != nil
      redirect_to '/store'
    end
  end
end
