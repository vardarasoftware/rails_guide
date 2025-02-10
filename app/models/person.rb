class GoodnessValidator < ActiveModel::Validator
    def validate(record)
      if options[:fields].any? { |field| record.send(field) == "Evil" }
        record.errors.add :base, "This person is evil"
      end
    end
end  
class Person < ApplicationRecord
    validates_with GoodnessValidator, fields: [ :name, :surname ]
    validates_each :name, :surname do |record, attr, value|
        record.errors.add(attr, "must start with upper case") if /\A[[:lower:]]/.match?(value)
    end
    validates :terms_of_service, acceptance: { accept: "yes" }
    validates :eula, acceptance: { accept: [ "TRUE", "accepted" ] }
    validates :email, confirmation: { case_sensitive: false }
    validates :email_confirmation, presence: true, if: :email_changed?
    validates :bio, length: { maximum: 500 }
    validates :password, length: { in: 6..20 }
    validates :registration_number, length: { is: 6 }
end
