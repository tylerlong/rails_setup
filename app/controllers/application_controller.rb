class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper

  private

    def guest_filter
      unless guest?
        flash[:info] = "You are not allowed to perform the action as a signed in user."
        redirect_to back_path
      end
    end

    def user_filter
      unless user?
        store_url
        flash[:info] = "Please sign in to continue."
        redirect_to signin_path
      end
    end

    def current_user_filter
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:error] = "Permission denied."
        redirect_to back_path
      end
    end

    def other_user_filter
      @user = User.find(params[:id])
      if current_user?(@user)
        flash[:error] = "You are not allowed to perform the action to yourself."
        redirect_to back_path
      end
    end

    def administrator_filter
      unless current_user.admin?
        flash[:error] = "Permission denied."
        redirect_to back_path
      end
    end

end