# encoding: utf-8
class DiscussionsController < ApplicationController
  def create
    content = params[:content]
    @topic = Topic.find(params[:topic_id])
    selected_emails = params[:selected_users].split(',')
    current_organization && discussion = Discussion.create_discussion(current_user, @topic, selected_emails, content)
    EmailEngine::DiscussionNotifier.new(discussion.id).create_discussion_notification
    discussions = @topic.discussions
    colleagues = get_colleagues(@topic)
    render :json => {
              :update => {
                          "discussion-list" => render_to_string(:partial => 'topics/discussion_list',
                                                                :layout => false,
                                                                :locals => {
                                                                  :discussions => discussions
                                                                }),
                           "new-discussion" => render_to_string(:partial => 'topics/new_discussion',
                                                                :layout => false,
                                                                :locals => {
                                                                  :colleagues => colleagues
                                                                })
                         }
                 }
  end
end
