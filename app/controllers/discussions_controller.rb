# encoding: utf-8
class DiscussionsController < ApplicationController
  before_filter :login_required, :organization_required

  def create
    @topic = Topic.find(params[:topic_id])
    selected_emails = (params[:selected_users_for_topic] || params[:selected_users_for_discussion]).split(',')
    discussion = Discussion.create_discussion(login_user, @topic, selected_emails, params[:content])
    DiscussionNotifierWorker.perform_async(discussion.id, selected_emails)

    render :json => {
              :update => {
                          "discussion-list" => render_to_string(:partial => 'topics/discussion_list',
                                                                :layout => false,
                                                                :locals => {
                                                                    :discussions => @topic.discussions
                                                                })
                         }
                 }
  end
end
