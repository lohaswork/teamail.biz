module ControllerModules::User
  extend ActiveSupport::Concern

  included do
    helper_method :login_user, :authenticated?, :currently_admin?
  end

  def get_colleagues
    current_organization.users.reject { |user| user.email == login_user.email }
  end

  def login_user=(user)
    @login_user = user
    cookies[:login_token] = user.remember_token
  end

  def login_user
    @login_user ||= cookies[:login_token] && ::User.find_by_remember_token(cookies[:login_token])
  end

  def authenticated?
    !!login_user
  end

  def currently_admin?
    login_user.is_admin?(current_organization)
  end

end
