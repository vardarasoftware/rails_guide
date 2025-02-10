class TokenGenerationException < StandardError; 
end
class Persontwo < ApplicationRecord
    validates :name, presence: { strict: true }
    validates :email, uniqueness: true, on: :account_setup
    validates :age, numericality: true, on: :account_setup
    validates :token, presence: true, uniqueness: true, strict: TokenGenerationException
end
