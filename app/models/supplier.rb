class Supplier < ApplicationRecord
    has_one :account
    validates :account, presence: true
end
