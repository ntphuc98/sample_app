class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".info_flash"
      redirect_to root_url
    else
      flash.now[:danger] = t ".danger_flash"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add :password, t(".error_password")
      render :edit
    elsif @user.update_attributes(user_params)          # Case (4)
      log_in @user
      @user.update_attribute :reset_digest, nil
      flash[:success] = t ".success_flash"
      redirect_to @user
    else
      render :edit # Case (2)
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t ".create.danger_flash"
    redirect_to new_password_reset_url
  end

  # Confirms a valid user.
  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])
    flash[:danger] = t ".danger_link"
    redirect_to root_url
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t ".danger_expired"
    redirect_to new_password_reset_url
  end
end
