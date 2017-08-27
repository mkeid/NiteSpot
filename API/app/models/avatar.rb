class Avatar < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :group
  belongs_to :place
  belongs_to :school
  belongs_to :service
  belongs_to :user
end
