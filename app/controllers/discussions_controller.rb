# encoding: utf-8
class DiscussionsController < ApplicationController
  before_filter :login_required, :organization_required

  def create
    @topic = Topic.find(params[:topic_id])
    selected_emails = params[:selected_emails] || []

    discussion = Discussion.create_discussion(login_user, @topic, selected_emails, params[:content])
    DiscussionNotifierWorker.perform_async(discussion.id, selected_emails)

    respond_array = []
    respond_array << "select-user-for-discussion" << get_rendered_string('shared/user_select_for_discussion', { topic: @topic.reload })
    respond_array << "discussion-list" << get_rendered_string('topics/discussion_list', { discussions: @topic.discussions })
    render :json => { update: Hash[*respond_array] }
  end
end
