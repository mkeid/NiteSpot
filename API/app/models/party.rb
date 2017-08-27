class Party < ActiveRecord::Base
  attr_accessible :address,
                  :description,
                  :name,
                  :public,
                  :time

  belongs_to :school

  has_many :invitations,
           :foreign_key => 'party_id',
           :dependent => :destroy
  has_many :invited_users,
           :through => :invitations,
           :foreign_key => 'user_id',
           :source => :user,
           :class_name => 'User'

  has_many :user_attendances,
           :dependent => :destroy
  has_many :users,
           :through => :user_attendances,
           :foreign_key => 'user_id',
           :source => :user,
           :class_name => 'User'

  has_one :shout

  belongs_to :group

  scope :on_day, lambda { |time|
    where('extract(year from time) = ?', time.year).where('extract(month from time) = ?', time.month).where('extract(day from time) = ?', time.day)
  }
  scope :relevant, where('extract(year from time) >= ?', Time.now.year).where('extract(month from time) >= ?', Time.now.month).where('extract(day from time) >= ?', Time.now.day)
  scope :today, where('extract(year from time) = ?', Time.now.year).where('extract(month from time) = ?', Time.now.month).where('extract(day from time) = ?', Time.now.day)
  scope :yesterday, where('extract(year from time) = ?', Time.now.year).where('extract(month from time) = ?', Time.now.month).where('extract(day from time) = ?', Time.now.day-1)

  def self.reset
    Party.yesterday.each do |party|
      party.destroy
    end
  end

end
