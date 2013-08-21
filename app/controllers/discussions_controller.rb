# encoding: utf-8
class DiscussionsController < ApplicationController
  def create
    content = params[:content]
    @topic = Topic.find(params[:topic_id])
    current_organization && Discussion.create_discussion(current_user.id, @topic.id, content)
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
