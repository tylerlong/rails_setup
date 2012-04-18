module SessionsHelper

  def sign_in(user)
    cookies[:remember_token] = user.remember_token
    current_user = user
  end

  def user?
    !current_user.nil?
  end

  def guest?
    current_user.nil?
  end

  def sign_out
    current_user = nil
    cookies.delete(:remember_token)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def current_user?(user)
    user == current_user
  end

  def store_url
    session[:url] = request.fullpath
  end

  def redirect_or(default)
    redirect_to(session[:url] || default)
    session.delete(:url)
  end

  private

    def user_from_remember_token
      remember_token = cookies[:remember_token]
      User.find_by_remember_token(remember_token) unless remember_token.nil?
    end

end