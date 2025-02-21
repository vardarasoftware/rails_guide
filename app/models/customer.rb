class Customer < ApplicationRecord
  has_many :order_twos
  has_many :reviews
end
