class User < ActiveRecord::Base
  attr_accessible :activation_token,
                  :active,
                  :avatar,
                  :email,
                  :gender,
                  :name_first,
                  :name_last,
                  :privacy,
                  :salt,
                  :year

  has_attached_file :avatar,
                    :styles => { :full => "100%", :small => "100x100", :thumb => "50x50", :tiny => '20x20' },
                    :default_url => "/users/avatar.png",
                    :path => ":rails_root/public/users/:id/:style/:filename",
                    :url => "/users/:id/:style/:filename"

  has_many :invitations,
           :foreign_key => 'user_id',
           :dependent => :destroy

  has_many :user_attendances
  has_many :party_attendances,
           :class_name => 'UserAttendance',
           :conditions => 'party_id IS NOT NULL'
  has_many :place_attendances,
           :class_name => 'UserAttendance',
           :conditions => 'place_id IS NOT NULL'
  has_many :parties,
           :through => :user_attendances,
           :foreign_key => 'party_id',
           :source => :party,
           :class_name => 'Party'
  has_many :places,
           :through => :user_attendances,
           :foreign_key => 'place_id',
           :source => :place,
           :class_name => 'Place',
           :order => 'place.name'

  has_many :user_favorites
  has_many :favorite_cabs,
           :through => :user_favorites,
           :foreign_key => 'cab_id',
           :source => :cab,
           :class_name => 'Cab'
  has_many :favorite_services,
           :through => :user_favorites,
           :source => :service,
           :foreign_key => 'service_id',
           :class_name => 'Service'
  
  has_many :group_memberships
  has_many :groups,
           :through => :group_memberships,
           :source => :group,
           :conditions => ['group_memberships.accepted = ?', true]

  has_many :network_requests
  has_many :requested_schools,
           :through => :network_requests,
           :source => :school,
           :foreign_key => 'school_id',
           :class_name => 'School'

  has_many :notifications,
           :dependent => :destroy

  has_many :requests

  has_many :shouts,
           :dependent => :destroy

  has_many :relationships,
           :foreign_key => 'follower_id',
           :dependent => :destroy

  has_many :reverse_relationships,
           :foreign_key => 'followed_id',
           :class_name => 'Relationship'

  has_many :school_memberships,
           :foreign_key => 'user_id',
           :dependent => :destroy
  has_many :schools,
           :through => :school_memberships,
           :foreign_key => 'school_id',
           :source => :school,
           :class_name => 'School'

  has_many :followed_users, :through => :relationships,
           :source => :followed,
           :conditions => ['relationships.accepted = ?', true]

  has_many :followers, :through => :reverse_relationships,
           :conditions => ['relationships.accepted = ?', true]




  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,3}$/i
  validates :email, :presence => true, :length => {:maximum => 50}, :format => EMAIL_REGEX
  validates :gender, :presence => true, :length => {:maximum => 6, :minimum => 4}
  validates :name_first, :presence => true, :length => {:maximum => 20, :minimum => 2}
  validates :name_last, :presence => true, :length => {:maximum => 20, :minimum => 2}
  validates :password, :presence => true
  validates :year, :presence => true, :length => {:maximum => 9, :minimum => 6}


  scope :active, where(:active => true)
  scope :inactive, where(:active => false)

  scope :female, where(:gender => 'female')
  scope :male, where(:gender => 'male')

  scope :fr, where(:year => 'freshmen')
  scope :so, where(:year => 'sophomore')
  scope :jr, where(:year => 'junior')
  scope :sr, where(:year => 'senior')

  scope :in_school, lambda { |school|
    where('school_id = ?', school.id)
  }
  scope :search, lambda { |query|
    where('name_first LIKE ? or name_last LIKE ? or concat(name_first, name_last) LIKE ?', "%#{query}%", "%#{query}%" , "%#{query}%")
  }

  scope :top_attendees, lambda { |place|
      joins('left outer join user_attendances on user_attendances.user_id = users.id inner join relationships on users.id = relationships.followed_id').
          select('COUNT(user_attendances.id) AS attendance_count').
          group('users.id').
          order('attendance_count DESC').
          where("user_attendances.place_id = #{place.id}").limit(10)
  }

  scope :morning, includes(:user_attendances).where('extract(year from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) = ?', Time.now.year).where('extract(month from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) = ?', Time.now.month).where('extract(day from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) = ?', Time.now.day).where('extract(hour from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) < ?', 8)
  scope :today, includes(:user_attendances).where('extract(year from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) = ?', Time.now.year).where('extract(month from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) = ?', Time.now.month).where('extract(day from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) = ?', Time.now.day).where('extract(hour from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) >= ?', 8)
  scope :yesterday, includes(:user_attendances).where('extract(year from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) = ?', Time.now.year).where('extract(month from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) = ?', Time.now.month).where('extract(day from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) = ?', Time.now.day-1).where('extract(hour from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) >= ?', 8)

  def ask_to_follow(other_user)
    relationships.create!(:followed_id => other_user.id, :accepted => false)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(:followed_id => other_user.id, :accepted => true)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def self.does_exist(email='')
    user = User.find_by_email(email)
    User.exists?(user.id) ? true : false
  end
  def self.hash_with_salt(password='', salt='')
  	Digest::SHA2.hexdigest("Include a #{salt} with the #{password} to increase security")
  end
  def self.make_salt(email='')
    Digest::SHA2.hexdigest("Create a salt out of the user's #{email} and the current #{Time.now} to further secure the password")
  end
end
