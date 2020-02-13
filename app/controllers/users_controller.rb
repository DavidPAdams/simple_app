class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.most_recent.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
    
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info]="Hello #{@user.name}, please check your email to activate your account"
      redirect_to root_url
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash.now[:success]="Profile successfully updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    dead_user = @user.name
    @user.destroy
    flash[:success] = "#{dead_user} was killed by the admin known as #{current_user.name}"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end
