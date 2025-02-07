class Holiday < ApplicationRecord
    validates :name, uniqueness: { scope: :holiday_date, message: "should happen once per year" }
end
