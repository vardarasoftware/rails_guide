class User < ApplicationRecord
  after_create :log_new_user

  private
    def log_new_user
      puts "A new user was registered"
    end
end
