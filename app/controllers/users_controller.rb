class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.per_page
  end

  def show
    if @user
      @user
    else
      flash[:danger] = t ".danger_flash"
      redirect_to root_url
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".info_flash"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t ".success_flash"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".success_flash"
    else
      flash[:danger] = t ".danger_flash"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".danger_flash"
    redirect_to login_url
  end

  # Confirms the correct user.
  def correct_user
    return if current_user?(@user)
    flash[:danger] = t ".danger_flash"
    redirect_to(root_url)
  end

  # Confirms an admin user.
  def admin_user
    return if current_user.admin?
    flash[:danger] = t ".danger_flash"
    redirect_to(root_url)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".danger_flash"
    redirect_to root_url
  end
end
