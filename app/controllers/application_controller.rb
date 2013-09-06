class ApplicationController < ActionController::Base
  include ControllerModules::ExceptionHandlers
  include ControllerModules::User
  include ControllerModules::Organization

  protect_from_forgery

  def access_organization
    redirect_to '/404.html' if !current_organization_accessable?
  end
end
