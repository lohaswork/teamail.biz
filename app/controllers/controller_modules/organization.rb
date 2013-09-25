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
        @current_organization ||= ::Organization.for_user(current_user).find(session[:organization])
      rescue
        nil
      end
    end

    def get_colleagues
      organization_users = current_organization.users
      organization_users.reject { |user| user.email == current_user.email }
    end

    def current_organization_accessable?
      !!current_organization
    end
end
