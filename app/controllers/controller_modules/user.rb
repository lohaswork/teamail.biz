module ControllerModules::User
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :authenticated?
  end

  def current_user=(user)
    @current_user = user
    cookies[:login_token] = user.remember_token
  end

  def current_user
    @current_user ||= cookies[:login_token] && User.find_by_remember_token(cookies[:login_token])
  end

  def authenticated?
    !!current_user
  end

end
