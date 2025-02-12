class Usertwo < ApplicationRecord
  has_many :notifications

  after_create :create_welcome_notification

  def create_welcome_notification
    notifications.create(event: "sign_up")
  end
end
