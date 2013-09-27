# encoding: utf-8
class TopicsController < ApplicationController
  before_filter :access_organization, :except => [:index]

  def index
    params[:organization_id] && params[:organization_id] != current_organization.try(:id) && update_current_organization(Organization.find(params[:organization_id]))
    redirect_to('/404.html') && return if !current_organization_accessable?
    @organization = current_organization
    @topics = order_by_updator @organization.topics
    @colleagues = get_colleagues
    @tags = @organization.tags
  end

  def create
    selected_emails = params[:selected_users].split(',')
    new_topic = Topic.create_topic(params[:title], params[:content], selected_emails, current_organization, current_user)
    EmailEngine::TopicNotifier.new(new_topic.id).create_topic_notification
    topics = order_by_updator current_organization.topics

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

  def add_tag
    selected_topics_ids = params[:selected_topics].split(',').uniq
    Topic.find(selected_topics_ids).each { |topic| topic.add_taggings(params[:tags]) }
    topics = order_by_updator Topic.find(params[:topics])

    render :json => {
              :update => {
                          "topic-list" => render_to_string(:partial => 'topics/topic_list',
                                                           :layout => false,
                                                           :locals => {
                                                               :topics => topics
                                                          })
                        }
                    }
  end

  def remove_tag
    tag_id = params[:tag]
    topic = Topic.find(params[:topic]).remove_tagging(tag_id)

    render :json => {
              :remove => ["tag-#{topic.id}-#{tag_id}"]
                    }
  end

end
