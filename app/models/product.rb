class Product < ApplicationRecord
    before_destroy do
        throw :abort if still_active?
    end
    validates :legacy_code, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
end
