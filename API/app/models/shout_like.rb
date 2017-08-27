class ShoutLike < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :shout
  belongs_to :user
end
