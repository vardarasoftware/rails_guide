class Book < ApplicationRecord
    validates :title, presence: true
    belongs_to :author
    belongs_to :library
end
