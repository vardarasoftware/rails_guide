class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id  # Store user ID in session
      redirect_to notebooks_path, notice: "Logged in successfully!"
    else
      flash[:alert] = "Invalid email or password."
      render :new
    end
  end
  
  def destroy
    session.delete(:user_id)  # Remove user from session
    redirect_to root_path, notice: "Logged out successfully."
  end
end
