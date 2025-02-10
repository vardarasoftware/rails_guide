class Company < ApplicationRecord
  has_many :publications, as: :publisher
end
