class Order < ApplicationRecord
    has_many :line_items, inverse_of: :order
    before_save :normalize_card_number, if: :paid_with_card?
    validates :card_number, presence: true, if: :paid_with_card?

    def normalize_card_number
        Rails.logger.info("Card number has been normalized!")
    end

    def paid_with_card?
        payment_type == "card"
    end
end
