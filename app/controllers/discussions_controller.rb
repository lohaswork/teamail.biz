# encoding: utf-8
class DiscussionsController < ApplicationController
  def create
    content = params[:content]
    @topic = Topic.find(params[:topic_id])
    current_organization && discussion = Discussion.create_discussion(current_user.id, @topic.id, content)
    EmailEngine::DiscussionNotifier.new(discussion.id).create_discussion_notification
    discussions = @topic.discussions
    render :json => {
              :update => {
                          "discussion-list" => render_to_string(:partial => 'topics/discussion_list',
                                                                :layout => false,
                                                                :locals => {
                                                                  :discussions => discussions
                                                                }),
                           "new-discussion" => render_to_string(:partial => 'topics/new_discussion',
                                                                :layout => false)
                         }
                 }
  end
end
