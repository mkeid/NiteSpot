class School < ActiveRecord::Base
  # attr_accessible :title, :body
  has_attached_file :avatar,
                    :styles => { :full => "100%", :small => "100x100", :thumb => "50x50" },
                    :default_url => "/schools/avatar.png",
                    :path => ":rails_root/public/schools/:id/:style/:filename",
                    :url => "/schools/:id/:style/:filename"

  has_and_belongs_to_many :cabs
  has_and_belongs_to_many :places,
                          :order => 'name ASC'
  has_and_belongs_to_many :services
  
  has_many :groups

  has_many :network_requests

  has_many :parties,
           :through => :groups

  has_many :school_memberships,
           :foreign_key => 'school_id',
           :dependent => :destroy
  has_many :users,
           :through => :school_memberships,
           :foreign_key => 'user_id',
           :source => :user,
           :class_name => 'User'

  def self.primary
    includes(:school_memberships).where('is_primary = ?', true).first
  end
end
