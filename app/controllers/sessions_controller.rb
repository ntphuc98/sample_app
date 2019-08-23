class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      check_activated user
    else
      flash.now[:danger] = t ".danger_flash"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def check_activated user
    if user.activated?
      log_in user
      remember? user
      redirect_back_or user
    else
      flash[:warning] = t ".warning_flash"
      redirect_to root_url
    end
  end

  def remember? user
    if params[:session][:remember_me] == Settings.remember_session
      remember(user)
    else
      forget(user)
    end
  end
end
