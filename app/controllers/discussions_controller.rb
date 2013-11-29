# encoding: utf-8
class DiscussionsController < ApplicationController
  before_filter :login_required, :organization_required

  def create
    @topic = Topic.find(params[:topic_id])
    selected_emails = params[:selected_emails] || []
    invited_emails = params[:invited_emails].split(/[\,\;]/).map { |email| email.strip }
    emails = get_valid(invited_emails).reject { |email| selected_emails.include? email.downcase }
    selected_emails.concat emails

    emails.reject { |email| current_organization.has_member?(email) }.each do |email|
      email_status = User.already_register?(email)
      current_organization.invite_user(email)
      InvitationNotifierWorker.perform_async(email, current_organization.name, login_user.email, email_status)
    end

    discussion = Discussion.create_discussion(login_user, @topic, selected_emails, params[:content])
    DiscussionNotifierWorker.perform_async(discussion.id, selected_emails)

    respond_array = []
    respond_array << "select-user-for-discussion" << get_rendered_string('shared/user_select_for_discussion', { topic: @topic.reload })
    respond_array << "discussion-list" << get_rendered_string('topics/discussion_list', { discussions: @topic.discussions })
    render :json => { update: Hash[*respond_array] }
  end
end
