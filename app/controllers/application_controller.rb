class ApplicationController < ActionController::Base
  include ControllerModules::ExceptionHandlers
  include ControllerModules::User

  protect_from_forgery

  def require_authenticate
    redirect_to login_path if !authenticated?
  end
end
