module ControllerModules::Organization
    extend ActiveSupport::Concern

  included do
    helper_method :current_organization
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

    def get_organizaiton_users(topic=nil)
      organization_users = current_organization.users
      #The is_in_topic should be matain by the active_user of the topic, they the members of the last discussion
      organization_users = organization_users.map{|user| {:email => user.email, :email_name => user.email_name, :is_in_topic => topic && topic.users.include?(user) || false} }
      organization_users.reject!{|user| user[:email] == current_user.email}
    end
end
