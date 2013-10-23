# encoding: utf-8
class DiscussionsController < ApplicationController
  before_filter :login_required, :organization_required

  def create
    @topic = Topic.find(params[:topic_id])
    selected_emails = (params[:selected_users_for_topic] || params[:selected_users_for_discussion]).split(',')

    invited_emails = params[:invited_emails].rstrip.split(/[\,\;]/)

    User.check_emails_validation(invited_emails)

    invited_emails.each do |invited_email|
      unless current_organization.has_member?(invited_email)
        email_status = User.already_register?(invited_email)
        current_organization.invite_user(invited_email)
        InvitationNotifierWorker.perform_async(
          invited_email, current_organization.name, login_user.email,
          email_status)
      end

      selected_emails << invited_email unless selected_emails.include? invited_email.downcase
    end

    discussion = Discussion.create_discussion(login_user, @topic, selected_emails, params[:content])
    DiscussionNotifierWorker.perform_async(discussion.id, selected_emails)

    respond_array = []

    respond_array << "select-user-for-topic" << render_to_string(partial: 'shared/user_select',
                                                       layout: false,
                                                       locals: {
                                                         topic: nil
                                                       })

    respond_array << "select-user-for-discussion" << render_to_string(partial: 'shared/user_select',
                                                       layout: false,
                                                       locals: {
                                                         topic: @topic
                                                       })

    respond_array << "discussion-list" << render_to_string(partial: 'topics/discussion_list',
                                                           layout: false,
                                                           locals: {
                                                             discussions: @topic.discussions
                                                           })

    render :json => { update: Hash[*respond_array] }
  end
end
