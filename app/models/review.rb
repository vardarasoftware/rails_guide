class Review < ApplicationRecord
  belongs_to :customer
  belongs_to :book_three

  enum :state, [ :not_reviewed, :published, :hidden ]
end
