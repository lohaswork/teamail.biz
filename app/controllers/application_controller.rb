class ApplicationController < ActionController::Base
  include ControllerModules::ExceptionHandlers
  include ControllerModules::User
  include ControllerModules::Organization

  protect_from_forgery
  before_filter :set_page_id

  def login_required
    redirect_to login_path if !is_logged_in?
  end

  def organization_required
    redirect_to no_organizations_path if !current_organization_exist?
  end

  def access_organization
    redirect_to '/404.html' if !Organization.for_user(login_user).find(params[:organization_id])
  end

  def set_page_id
    @page_id = "#{controller_name.underscore}_#{action_name}_page".camelize
  end
end
