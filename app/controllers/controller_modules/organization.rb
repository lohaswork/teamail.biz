module ControllerModules::Organization
    extend ActiveSupport::Concern

  included do
    helper_method :current_organization, :get_colleagues
  end

  protected
    # 仅在手动切换default_organization时更新current_organization
    def update_current_organization(organization)
      begin
       session[:organization] = organization.id
      rescue
        nil
      end
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

    def add_member_from_discussion(emails)
      emails = get_valid emails
      emails.reject { |email| current_organization.has_member?(email) }.each do |email|
        is_registered_user = User.already_register?(email)
        current_organization.add_member_by(email)
        InvitationNotifierWorker.perform_async(email, current_organization.name, login_user.email, is_registered_user)
      end
    end
end
