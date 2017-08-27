class OrderedProduct < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :products

  belongs_to :order
end
