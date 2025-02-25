class AuthorThree < ApplicationRecord
    has_many :book_threes, -> { order(year_published: :desc) }
end
