class UserFavorite < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :service

  belongs_to :cab, :class_name => 'Cab'
  belongs_to :service, :class_name => 'Service'

end
