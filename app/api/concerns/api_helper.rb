#Helper mehtod goes here

module ApiHelper
  extend ActiveSupport::Concern

  included do |base|
    helpers HelperMethods
  end

  module HelperMethods
    def current_user
      @current_user ||= OauthAccessToken.find_by(:token, params[:access_token]).user
    end

    def current_organization
      begin
        @current_organization ||= ::Organization.for_user(@current_user).find(@current_user.default_organization_id)
      rescue
        nil
      end
    end
  end
end
