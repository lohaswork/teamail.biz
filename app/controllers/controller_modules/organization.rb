module ControllerModules::Organization
    extend ActiveSupport::Concern

  included do
    helper_method :current_organization
  end

  protected
    def update_organization(organization)
      session[:organization] = organization.id
    end

    def current_organization
      @current_organization ||= session[:organization] && current_user && ::Organization.for_user(current_user).find(session[:organization])
    end
end
