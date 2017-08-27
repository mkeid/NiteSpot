class Shout < ActiveRecord::Base
  attr_accessible :reference_name, :referenced_group_id, :referenced_party_id, :referenced_place_id, :shout_type, :user_id

  belongs_to :group
  belongs_to :party
  belongs_to :user

  has_many :shout_likes,
           :foreign_key => 'shout_id',
           :dependent => :destroy

  has_many :liked_users,
           :through => :shout_likes,
           :source => :user
end
