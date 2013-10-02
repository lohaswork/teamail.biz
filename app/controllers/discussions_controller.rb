# encoding: utf-8
class DiscussionsController < ApplicationController
  before_filter :access_organization

  def create
    @topic = Topic.find(params[:topic_id])
    selected_emails = params[:selected_users].split(',')
    discussion = Discussion.create_discussion(login_user, @topic, selected_emails, params[:content])
    EmailEngine::DiscussionNotifier.new(discussion.id).create_discussion_notification

    render :json => {
              :update => {
                          "discussion-list" => render_to_string(:partial => 'topics/discussion_list',
                                                                :layout => false,
                                                                :locals => {
                                                                  :discussions => @topic.discussions
                                                                }),
                           "new-discussion" => render_to_string(:partial => 'topics/new_discussion',
                                                                :layout => false,
                                                                :locals => {
                                                                  :colleagues => get_colleagues
                                                                })
                         }
                 }
  end
end
