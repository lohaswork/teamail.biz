# encoding: utf-8
class DiscussionsController < ApplicationController
  before_filter :login_required, :organization_required

  def create
    @topic = Topic.find(params[:topic_id])
    selected_emails = params[:selected_emails] || []
    invited_emails = params[:invited_emails].split(/[\,\;]/).map { |email| email.strip }
    check_emails_validation(invited_emails)

    invited_emails.each do |invited_email|
      unless current_organization.has_member?(invited_email)
        email_status = User.already_register?(invited_email)
        current_organization.invite_user(invited_email)
        InvitationNotifierWorker.perform_async(invited_email, current_organization.name, login_user.email, email_status)
      end
      selected_emails << invited_email unless selected_emails.include? invited_email.downcase
    end

    discussion = Discussion.create_discussion(login_user, @topic, selected_emails, params[:content])
    DiscussionNotifierWorker.perform_async(discussion.id, selected_emails)

    respond_array = []
    respond_array << "select-user-for-discussion" << get_rendered_string('shared/user_select_for_discussion', { topic: @topic.reload })
    respond_array << "discussion-list" << get_rendered_string('topics/discussion_list', { discussions: @topic.discussions })
    render :json => { update: Hash[*respond_array] }
  end
end
