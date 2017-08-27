class Group < ActiveRecord::Base
  attr_accessible :avatar
  has_attached_file :avatar,
                    :styles => { :full => "100%", :thumb => "50x50", :medium => '165x165', :large => '300x300', :tiny => '20x20' },
                    :default_url => "/groups/avatar.png",
                    :path => ":rails_root/public/groups/:id/:style/:filename",
                    :url => "/groups/:id/:style/:filename"

  belongs_to :school
  
  has_many :group_memberships,
           :foreign_key => 'group_id',
           :dependent => :destroy


  has_many :members,
           :through => :group_memberships,
           :source => :member,
           :conditions => ['group_memberships.accepted = ?', true]

  has_many :admins,
           :through => :group_memberships,
           :source => :member,
           :conditions => ['group_memberships.is_admin = ?', true]

  has_many :parties,
           :dependent => :destroy

  has_many :requests

  has_many :shouts

  scope :in_school, lambda { |school|
    where('school_id = ?', school.id)
  }
  scope :search, lambda { |query|
    where('name LIKE ?', "%#{query}%")
  }

end
