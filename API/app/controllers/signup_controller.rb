class SignupController < ApplicationController
	def index
	  if session[:user_id] != nil
	    redirect_to "/"
	  end
	end
end
