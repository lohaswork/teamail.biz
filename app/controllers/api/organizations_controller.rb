class Api::OrganizationsController < Api::BaseController
  def members
    organization =  Organization.find params[:id]
    respond_with :api, get_colleagues
  end
end
