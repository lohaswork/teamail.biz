module ControllerModules::User
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :authenticated?, :currently_admin?
  end

  def get_colleagues
    current_organization.users.reject { |user| user.email == current_user.email }
  end

  def current_user=(user)
    @current_user = user
    cookies[:login_token] = user.remember_token
  end

  def current_user
    @current_user ||= cookies[:login_token] && ::User.find_by_remember_token(cookies[:login_token])
  end

  def authenticated?
    !!current_user
  end

  def currently_admin?
    current_user.is_admin?(current_organization)
  end

end
