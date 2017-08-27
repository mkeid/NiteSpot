class Order < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :ordered_products

  belongs_to :service
  belongs_to :user
end
