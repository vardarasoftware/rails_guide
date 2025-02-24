class BookTwo < ApplicationRecord
  belongs_to :authortwo, counter_cache: :count_of_books
end
