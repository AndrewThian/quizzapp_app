class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # checking if current user is authenticated
  def is_authenticated
    unless current_user
      flash[:danger] = "You're not logged in!"
      redirect_to login_path
    end
  end

  # Checking if current user is in database
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  helper_method :current_user
end
