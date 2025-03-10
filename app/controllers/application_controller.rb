class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  layout "main"
  protect_from_forgery with: :exception

  helper_method :current_user

  def logged_in?
    session[:user_id].present?  # Check if a user session exists
  end

  private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
end
