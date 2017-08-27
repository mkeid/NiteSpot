class NetworkRequest < ActiveRecord::Base
  attr_accessible :school_id, :user_id

  belongs_to :school
  belongs_to :user
end
