class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  layout "main"

  helper_method :current_user
  helper_method :logged_in?

  before_action :require_login
  
  def logged_in?
    session[:user_id].present?  # Check if a user session exists
  end
  
  private
    def require_login
      unless logged_in?
        flash[:error] = "You must be logged in to access this section"
        redirect_to login_path unless request.path == login_path
      end
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
end
