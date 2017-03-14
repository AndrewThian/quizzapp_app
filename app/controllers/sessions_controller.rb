class SessionsController < ApplicationController
  def new
    if current_user.present?
      # if user has sessions token, redirect to home page.
      redirect_to root_path
    end
  end

  def create
    @user = User.authenticate(user_params)

    if @user
      # access sessions = user.id
      session[:user_id] = @user.id
      flash[:succes] = "You've successfully logged in!"
      redirect_to root_path
    else
      flash[:danger] = "Password / Email invalid, please try again.."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    cookies.signed[:user_id] = nil
    flash[:success] = "You have logged out."
    # redirect to home page
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password
    )
  end
end
