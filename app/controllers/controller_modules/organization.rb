module ControllerModules::Organization
    extend ActiveSupport::Concern

  included do
    helper_method :current_organization, :get_colleagues, :current_organization_admin?
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

    def current_organization_admin?
      OrganizationMembership.current_pair(current_user, current_organization).first.authority_type == 1
    end

    def current_organization_accessable?
      !!current_organization
    end
end
