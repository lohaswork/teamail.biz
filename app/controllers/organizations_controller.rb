# encoding: utf-8
class OrganizationsController < ApplicationController
  before_filter :login_required, :organization_required

  def change_default_organization
    login_user.update_attribute(:default_organization_id, params[:organization])
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
    new_member_emails = get_valid_emails params[:user_emails]
    emails = new_member_emails.reject do |email|
      User.find_by(email: email) && User.find_by(email: email).is_formal_member?(current_organization)
    end
    emails.each do |email|
      user = User.find_by(email: email)
      if !user || !user.formal_type?
        is_registered_user = false
      else
        is_registered_user = true
      end
      current_organization.add_member_by_email(email)
      InvitationNotifierWorker.perform_async(email, current_organization.name, login_user.email, is_registered_user)
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
