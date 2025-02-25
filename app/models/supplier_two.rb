class SupplierTwo < ApplicationRecord
  has_many :book_threes
  has_many :author_threes, through: :book_threes
end
