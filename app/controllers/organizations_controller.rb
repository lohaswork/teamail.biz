# encoding: utf-8
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
    organization = current_organization
    unless organization.has_member?(new_member_email)
      email_status = User.already_on_board?(new_member_email)
      organization.invite_user(new_member_email)
      EmailEngine::InvitationNotifier.new(new_member_email, organization, current_user).invitation_notification(email_status)
    end
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
