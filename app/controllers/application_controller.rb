class ApplicationController < ActionController::Base
  include ControllerModules::ExceptionHandlers
  include ControllerModules::User
  include ControllerModules::Organization
  include ControllerModules::Topic

  protect_from_forgery
  before_filter :set_page_id, :set_cache_buster

  def login_required
    redirect_to login_path if !is_logged_in?
  end

  def organization_required
    redirect_to no_organizations_path if !current_organization_exist?
  end

  def set_page_id
    @page_id = "#{controller_name.underscore}_#{action_name}_page".camelize
  end

  def get_rendered_string(partial, locals= {})
    render_to_string(partial: partial,
                     layout: false,
                     locals: locals)
  end

  protected

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
