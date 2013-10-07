module ControllerModules::Organization
    extend ActiveSupport::Concern

  included do
    helper_method :current_organization, :get_colleagues
  end

  protected
    # 仅在手动切换default_organization时更新current_organization
    def update_current_organization(organization)
      session[:organization] = organization.id
    end

    def current_organization
      begin
        @current_organization ||= ::Organization.for_user(login_user).find(session[:organization] || login_user.default_organization_id)
      rescue
        nil
      end
    end

    def current_organization_exist?
      !!current_organization
    end
end
