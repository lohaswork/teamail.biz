# encoding: utf-8
class TopicsController < ApplicationController
    # use before_filter for current_organization check

  def index
    organization_id = params[:organization_id]
    organization_id && update_current_organization(Organization.find(organization_id))
    @topics = current_organization && current_organization.topics_by_active_time
    @colleagues = current_organization && get_colleagues
  end

  def create
    selected_emails = params[:selected_users].split(',')
    unless current_organization && new_topic = Topic.create_topic(params[:title], params[:content], selected_emails, current_organization, current_user)
      redirect_to root_path
    end
    EmailEngine::TopicNotifier.new(new_topic.id).create_topic_notification
    topics = current_organization.topics_by_active_time
    render :json => {
              :update => {
                          "topic-list" => render_to_string(:partial => 'topic_list',
                                                            :layout => false,
                                                            :locals => {
                                                                  :topics => topics
                                                                }),
                           "new-topic" => render_to_string(:partial => 'new_topic',
                                                            :layout => false,
                                                            :locals => {
                                                                  :colleagues => get_colleagues(new_topic)
                                                              })
                         }
                 }
  end

  def show
    @topic = Topic.find(params[:id])
    @discussions = @topic.discussions
    @colleagues = get_colleagues(@topic)
  end
end
