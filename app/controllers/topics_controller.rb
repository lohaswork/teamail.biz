# encoding: utf-8
class TopicsController < ApplicationController
    # use before_filter for current_organization check

  def index
    organization_id = params[:organization_id]
    organization_id && update_current_organization(Organization.find(organization_id))
    @topics = current_organization && current_organization.topics_by_active_time
    @organization_users = current_organization && get_organizaiton_users
  end

  def create
    selected_emails = params[:topic_users].split(',')
    unless current_organization && new_topic = Topic.create_new_topic(params[:title], params[:content], selected_emails, current_organization.id, current_user.id)
      redirect_to root_path
    end
    EmailEngine::TopicNotifier.new(new_topic.id).create_topic_notifaction
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
                                                                  :organization_users => get_organizaiton_users(new_topic)
                                                              })
                         }
                 }
  end

  def show
    @topic = Topic.find(params[:id])
    @discussions = @topic.discussions
  end

  protected

  def get_organizaiton_users(topic=nil)
    organization_users = current_organization.users
    #add defalut selecte later
    organization_users.map{|user| {:emails => user.email, :topic => topic && topic.users.include?(user) || false} }
    organization_users.reject!{|user| user.email == current_user.email}
  end
end
