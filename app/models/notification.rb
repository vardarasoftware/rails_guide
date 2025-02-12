class Notification < ApplicationRecord
    belongs_to :usertwo
    validates :event, presence: true
end
