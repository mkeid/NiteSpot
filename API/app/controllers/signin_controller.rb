class SigninController < ApplicationController
  def index
    if session[:user_id] != nil
      redirect_to '/'
    end
    if params.has_key?(:signin) && params.has_key?(:password)
      user = User.find_by_email(params[:signin])
      if !user.present?
        user = User.find_by_handle(params[:signin])
      end

      hashed_password = User.hash_with_salt(params[:password], user.salt)
      if user.password == hashed_password && user.active == true
        if params.has_key?(:mobile) && params[:mobile] == true
        else
          session[:user_id] = user.id
          cookies[:gender] = user.gender
          cookies[:id] = user.id
          #cookies[:name_first] = user.name_first
          #cookies[:name_last] = user.name_last
          cookies[:privacy] = user.privacy
          cookies[:account_type] = "user"
          cookies[:year] = user.year
          if user.schools.count != 0
            redirect_to '/places'
          else
            redirect_to '/portal'
          end
        end
      else
        redirect_to '/signin?s=invalid'
      end
    end
  end
end