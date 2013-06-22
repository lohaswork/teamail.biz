class ApplicationController < ActionController::Base
  include ControllerModules::ExceptionHandlers

  protect_from_forgery
end
