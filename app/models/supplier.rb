class Supplier < ApplicationRecord
    has_one :account, ->(supplier) { where active: supplier.active? }
    has_one :account_history, through: :account
end
