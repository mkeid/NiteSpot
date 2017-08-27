class GroupMembership < ActiveRecord::Base
  attr_accessible :is_admin
  attr_accessible :user_id
  
  belongs_to :member, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :group
end
