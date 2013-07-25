module ControllerModules::Organization
    extend ActiveSupport::Concern

  included do
    helper_method :current_organization
  end

  protected
    def current_organization=(organization)
      @current_organization = organization
      session[:organization] = organization.id
    end

    def current_organization
      @organization ||= session[:organization] && Organization.find(session[:organization])
    end
end
