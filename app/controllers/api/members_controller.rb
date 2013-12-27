class Api::MembersController < Api::BaseController
  def index
    respond_with :api, get_colleagues
  end

  def create
    debugger
    render :nothing => true
  end
end
