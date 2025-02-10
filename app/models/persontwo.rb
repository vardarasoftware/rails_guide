class TokenGenerationException < StandardError; 
end
class Persontwo < ApplicationRecord
    validates :name, presence: true, on: :create
    validates :email, format: URI::MailTo::EMAIL_REGEXP
    validates :age, numericality: true, on: :account_setup
    validates :token, presence: true, uniqueness: true, strict: TokenGenerationException
    validates_with MyOtherValidator, strict: true
end
