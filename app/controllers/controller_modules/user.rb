module ControllerModules::User
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :authenticated?
  end

  def current_user=(user)
    @current_user = user
    cookies.permanent.signed[:remember_me] = user.id
  end

  def current_user
    @current_user ||= User.find(cookies.signed[:remember_me]) if cookies.signed[:remember_me]
  end

  def authenticated?
    !!current_user
  end

end
