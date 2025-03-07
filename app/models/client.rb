class Client < ApplicationRecord
  scope :activated, -> { where(status: "activated") }
  scope :inactivated, -> { where(status: "inactivated") }
  validates :status, presence: true
end
