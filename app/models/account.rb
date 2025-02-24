class Account < ApplicationRecord
    belongs_to :supplier, inverse_of: :account
    validates :account_number, presence: true
    has_one :account_history, dependent: :destroy
end
