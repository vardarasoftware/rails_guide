class MovieGenre < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
