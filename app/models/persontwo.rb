class TokenGenerationException < StandardError
end
class Persontwo < ApplicationRecord
    validate do |person|
        errors.add :name, :too_plain, message: "is not cool enough"
        errors.add :base, :invalid, message: "This person is invalid because ..."
    end
    validates :name, presence: true, on: :create, length: { minimum: 3 }
    validates :email, format: URI::MailTo::EMAIL_REGEXP
    validates :age, numericality: true, on: :account_setup
    validates :token, presence: true, uniqueness: true, strict: TokenGenerationException
    validates_with MyOtherValidator, strict: true
end
