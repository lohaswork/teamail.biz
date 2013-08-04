class ApplicationController < ActionController::Base
  include ControllerModules::ExceptionHandlers
  include ControllerModules::User
  include ControllerModules::Organization

  protect_from_forgery

end
