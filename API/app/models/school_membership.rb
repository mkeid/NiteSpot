class SchoolMembership < ActiveRecord::Base
  attr_accessible :school_id, :user_id, :is_primary

  belongs_to :school
  belongs_to :user
end
