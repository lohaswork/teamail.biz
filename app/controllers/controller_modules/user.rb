module ControllerModules::User
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :authenticated?
  end

  def current_user=(user)
    @current_user = user
    cookies[:remember_me] = user.remember_token
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_me]) if cookies[:remember_me]
  end

  def authenticated?
    !!current_user
  end

end
