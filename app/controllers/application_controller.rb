class ApplicationController < ActionController::Base
  include ControllerModules::ExceptionHandlers
  include ControllerModules::User
  include ControllerModules::Organization

  protect_from_forgery
  before_filter :set_page_id

  def access_organization
    redirect_to '/404.html' if !current_organization_accessible?
  end

  def set_page_id
    @page_id = "#{controller_name.underscore}_#{action_name}_page".camelize
  end
end
