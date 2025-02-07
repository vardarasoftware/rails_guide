class LineItem < ApplicationRecord
  belongs_to :order
  validates :order, absence: true
end
