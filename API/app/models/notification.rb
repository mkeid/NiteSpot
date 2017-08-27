class Notification < ActiveRecord::Base
  attr_accessible :from_group, :from_user, :notification_type, :user_id
  belongs_to :group
  belongs_to :group_from,
             :foreign_key => :from_group,
             :class_name => 'Group'
  belongs_to :user
  belongs_to :user_from,
             :foreign_key => :from_user,
             :class_name => 'User'

  scope :unchecked, where(:unchecked => true)
end
