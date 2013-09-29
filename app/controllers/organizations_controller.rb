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

  def add_member
    new_member_email = params[:user_email]
    email_status = User.already_on_board?(new_member_email)
    organization = current_organization
    invitation_from = current_user
    organization.invite_user(new_member_email)
    EmailEngine::InvitationNotifier.new(new_member_email, organization, invitation_from).invitation_notification(email_status)
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
