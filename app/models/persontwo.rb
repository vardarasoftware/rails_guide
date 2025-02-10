class Persontwo < ApplicationRecord
    validates :name, presence: true
    validates :email, uniqueness: true, on: :account_setup
    validates :age, numericality: true, on: :account_setup
end
