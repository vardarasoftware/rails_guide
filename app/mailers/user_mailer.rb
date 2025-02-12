class UserMailer < ApplicationMailer
    def welcome_email(user)
      @user = user
      mail(to: @user.email, subject: "Welcome to Our Platform!")
    end
    def confirmation_email(user)
      @user = user
      mail(to: @user.email, subject: 'Confirm Your Email')
    end
end
  