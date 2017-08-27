class MeController < ApplicationController
  def index
    signed_in?
    redirect_to "/users/#{@user_self.id}/feed" if @user_self != nil
    @user = @user_self if @user_self != nil
  end

  def test
    user_signed_in?
  end
end
