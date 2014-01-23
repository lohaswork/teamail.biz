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
     @current_organization = organization
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

  def add_informal_member_to_organization(emails)
    emails = emails.reject do |email|
      current_organization.users.include?(User.find_by(email: email)) if User.find_by(email: email)
    end
    emails.each { |email| current_organization.add_member_by_email(email, false) } unless emails.blank?
  end
end
