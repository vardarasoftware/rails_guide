class Book < ApplicationRecord
    validates :name, presence: true
end

Book::Order.table_name
