module ControllerModules::Organization
    extend ActiveSupport::Concern

  included do
    helper_method :current_organization, :get_colleagues
  end

  protected
    def update_current_organization(organization)
      session[:organization] = organization.id
    end

    def current_organization
      begin
        @current_organization ||= ::Organization.for_user(login_user).find(session[:organization])
      rescue
        nil
      end
    end

    def current_organization_accessible?
      !!current_organization
    end
end
