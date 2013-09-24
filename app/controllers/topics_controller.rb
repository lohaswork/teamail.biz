# encoding: utf-8
class TopicsController < ApplicationController
  before_filter :access_organization, :except => [:index]

  def index
    params[:organization_id] && update_current_organization(Organization.find(params[:organization_id])) if !current_organization_accessable?
    redirect_to('/404.html') && return if !current_organization
    @topics = current_organization.topics_by_active_time
    @colleagues = get_colleagues
    @tags = current_organization.tags
    @organization = current_organization
  end

  def create
    selected_emails = params[:selected_users].split(',')
    new_topic = Topic.create_topic(params[:title], params[:content], selected_emails, current_organization, current_user)
    EmailEngine::TopicNotifier.new(new_topic.id).create_topic_notification
    topics = current_organization.topics_by_active_time
    render :json => {
              :update => {
                          "topic-list" => render_to_string(:partial => 'topic_list',
                                                            :layout => false,
                                                            :locals => {
                                                                  :topics => topics
                                                                }),
                           "new-topic" => render_to_string(:partial => 'shared/new_topic',
                                                            :layout => false,
                                                            :locals => {
                                                                  :colleagues => get_colleagues
                                                              })
                         }
                 }
  end

  def show
    @topic = Topic.find(params[:id])
    @discussions = @topic.discussions
    @colleagues = get_colleagues
  end

end
