class Place < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :avatar
  has_attached_file :avatar,
                    :styles => { :medium => "180x180",
                                 :thumb => "100x100>" },
                    :default_url => '/places/avatar.png'

  has_and_belongs_to_many :schools

  has_many :notifications
  has_many :shouts

  has_many :user_attendances,
           :dependent => :destroy
  has_many :users,
           :through => :user_attendances,
           :foreign_key => 'user_id',
           :source => :user,
           :class_name => 'User'

  scope :inactive, where(:active => false)
  scope :owned, where(:owned => true)
  scope :unowned, where(:owned => false)


  scope :search, lambda { |query|
    where('name LIKE ?', "%#{query}%")
  }

  scope :today, includes(:user_attendances).where('extract(year from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) = ?', Time.now.year).where('extract(month from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) = ?', Time.now.month).where('extract(day from CONVERT_TZ(user_attendances.created_at, "+00:00", "-04:00")) = ?', Time.now.day)

end
