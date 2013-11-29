# encoding: utf-8
class DiscussionsController < ApplicationController
  before_filter :login_required, :organization_required

  def create
    @topic = Topic.find(params[:topic_id])
    selected_emails = params[:selected_emails] || []
    invited_emails = params[:invited_emails].split(/[\,\;]/).map { |email| email.strip.downcase }

    # Validate invite emails and add member by emails and send invitation emails at meantime
    add_member_from_discussion(invited_emails)

    # Get discussion notify party by add invited_emails and selected_emails,
    #   then send discussion notifications
    selected_emails = selected_emails.concat(invited_emails).uniq
    discussion = Discussion.create_discussion(login_user, @topic, selected_emails, params[:content])
    DiscussionNotifierWorker.perform_async(discussion.id, selected_emails)

    respond_array = []
    respond_array << "select-user-for-discussion" << get_rendered_string('shared/user_select_for_discussion', { topic: @topic.reload })
    respond_array << "discussion-list" << get_rendered_string('topics/discussion_list', { discussions: @topic.discussions })
    render :json => { update: Hash[*respond_array] }
  end
end
