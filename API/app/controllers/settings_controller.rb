class SettingsController < ApplicationController
  def index
    user_signed_in?
  end
end
