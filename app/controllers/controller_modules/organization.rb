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
      begin
        @current_organization ||= ::Organization.for_user(current_user).find(session[:organization])
      rescue
        nil
      end
    end
end
