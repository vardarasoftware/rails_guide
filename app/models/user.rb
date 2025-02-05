class User < ApplicationRecord
  validates :name, presence: true
  after_create :log_new_user

  private
    def log_new_user
      puts "A new user was registered"
    end
end
