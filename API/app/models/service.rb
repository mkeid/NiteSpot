class Service < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :avatar
  has_attached_file :avatar, :styles => { :medium => '300x300>', :thumb => '100x100>' }, :default_url => '/services/avatar.png'


  has_and_belongs_to_many :schools

  scope :in_school, lambda {|school| where(:school => school)}
  scope :owned, where(:owned => true)
  scope :unowned, where(:owned => false)

  def self.hash_with_salt(password='', salt='')
    Digest::SHA2.hexdigest("Include a #{salt} with the #{password} to increase security")
  end
  def self.make_salt(email='')
    Digest::SHA2.hexdigest("Create a salt out of the service's #{email} and the current #{Time.now} to further secure the password")
  end

end
