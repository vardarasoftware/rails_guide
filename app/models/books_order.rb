class BooksOrder < ApplicationRecord
  belongs_to :book_three
  belongs_to :order_two
end
