class UsersController < ApplicationController
  before_filter :guest_filter, only: [:new, :create]
  before_filter :user_filter, except: [:new, :create]
  before_filter :current_user_filter, only: [:edit, :update]
  before_filter :administrator_filter, only: [:index, :destroy]
  before_filter :other_user_filter, only: [:destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to #{CONFIG['site_name']}."
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = 'Profile updated.'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
end