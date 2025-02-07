class Promotion < ApplicationRecord
    validates :end_date, comparison: { greater_than: :start_date }
end
