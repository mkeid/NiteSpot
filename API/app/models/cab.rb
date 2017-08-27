class Cab < ActiveRecord::Base
  # attr_accessible :title, :body

  has_and_belongs_to_many :schools

  scope :in_school, lambda {|school| where(:school => school)}
  scope :owned, where(:owned => true)
  scope :unowned, where(:owned => false)
end
