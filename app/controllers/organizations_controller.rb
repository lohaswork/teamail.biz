# encoding: utf-8
class OrganizationsController < ApplicationController
  before_filter :login_required, :organization_required

  def show_member
    @colleagues = get_colleagues
  end

  def delete_member
    current_organization.delete_user(params[:user])
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
      is_registered_user = User.already_register?(new_member_email)
      organization.invite_user(new_member_email)
      EmailEngine::InvitationNotifier.new(new_member_email, organization, login_user, is_registered_user).invitation_notification
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
