# encoding: utf-8
class OrganizationsController < ApplicationController
  before_filter :login_required, :organization_required

  def change_default_organization
    login_user.default_organization_id = params[:organization]
    update_current_organization(login_user.default_organization)
    redirect_to personal_topics_inbox_path
  end

  def show_member
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
      organization.add_member_by_email(new_member_email)
      InvitationNotifierWorker.perform_async(new_member_email, organization.name, login_user.email, is_registered_user)
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

  def invite_member_again
    member = User.find params[:user]
    InvitationNotifierWorker.perform_async(member.email, current_organization.name, login_user.email, is_registered_user = false)
    render :json => {
               :modal => {
                 "message-dialog" => render_to_string(:partial => 'shared/error_and_notification',
                                                      :locals => { notice: "邮件发送成功！" },
                                                      :layout => false)
                         }
                    }
  end

  def set_organization_name
    name = params[:organization_name].strip
    current_organization.set_name name
    render :json => { :reload => true }
  end
end
