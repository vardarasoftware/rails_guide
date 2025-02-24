class ProductTwo < ApplicationRecord
    has_many :pictures, as: :imageable
end
