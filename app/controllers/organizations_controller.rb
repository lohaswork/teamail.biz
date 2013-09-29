class OrganizationsController < ApplicationController
  before_filter :access_organization

  def show_member
    @colleagues = get_colleagues
  end

  def downsize
    current_organization.cut_down(params[:user])
    colleagues = get_colleagues

    render :json => {
              :update => {
                "member-list" => render_to_string(:partial => 'organizations/member_list',
                                                  :layout => false,
                                                  :locals => {
                                                      :colleagues => colleagues
                                                  })
                        }
                    }
  end
end
