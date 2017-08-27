class UserAttendance < ActiveRecord::Base
  attr_accessible :party_id, :place_id, :user_id

  def get_array(objects, return_type)
    array = Array.new
    case return_type
      when 'id'
        objects.each do |object|
          array << object.id
        end
    end
    array
  end

  belongs_to :party
  belongs_to :place
  belongs_to :user

  scope :female, includes(:user).where('user.gender = ?', 'female')
  scope :male, includes(:user).where('user.gender = ?', 'male')
  scope :parties,:conditions => 'party_id IS NOT NULL'
  scope :places,:conditions => 'place_id IS NOT NULL'
  scope :morning, where('extract(year from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', Time.now.year).where('extract(month from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', Time.now.month).where('extract(day from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', Time.now.day).where('extract(hour from CONVERT_TZ(created_at, "+00:00", "-04:00")) < ?', 4)
  scope :today, where('extract(year from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', Time.now.year).where('extract(month from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', Time.now.month).where('extract(day from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', Time.now.day).where('extract(hour from CONVERT_TZ(created_at, "+00:00", "-04:00")) >= ?', 4)
  scope :yesterday, where('extract(year from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', Time.now.year).where('extract(month from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', Time.now.month).where('extract(day from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', Time.now.day-1).where('extract(hour from CONVERT_TZ(created_at, "+00:00", "-04:00")) >= ?', 4)
  scope :this_month, where('extract(year from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', Time.now.year).where('extract(month from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', Time.now.month)
  scope :fr, includes(:user).where('user.year = ?', 'freshmen')
  scope :so, includes(:user).where('user.year = ?', 'sophomore')
  scope :jr, includes(:user).where('user.year = ?', 'junior')
  scope :sr, includes(:user).where('user.year = ?', 'senior')

  scope :in_school, lambda { |school|
    {
        :conditions => ['place_id in (?)', school.places(:select => :id)]
    }
  }
  scope :not_user, lambda { |user|
    {
        :conditions => ['user_id IS NOT ?', user.id]
    }
  }
  
  scope :on_date, lambda { |time|
    where('extract(year from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', time.year).where('extract(month from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', time.month).where('extract(day from CONVERT_TZ(created_at, "+00:00", "-04:00")) = ?', time.day)
  }
end
