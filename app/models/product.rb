class Product < ApplicationRecord
    validates :legacy_code, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
end
