class Supplier < ApplicationRecord
    has_one :account, dependent: :destroy
    has_one :account_history, through: :account
end
