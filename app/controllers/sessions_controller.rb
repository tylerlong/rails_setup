class SessionsController < ApplicationController
  before_filter :guest_filter, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      sign_in user
      flash[:success] = "Signed in."
      redirect_or user
    else
      flash.now[:error] = 'Invalid email/password combination.'
      render 'new'
    end
  end

  def destroy
    sign_out
    flash[:info] = "Signed out."
    redirect_to root_path
  end
end