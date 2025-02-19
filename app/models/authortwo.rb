class Authortwo < ApplicationRecord
    has_many :book_twos, dependent: :destroy
    validates :name, presence: true
end
