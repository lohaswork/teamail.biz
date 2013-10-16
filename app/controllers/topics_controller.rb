# encoding: utf-8
class TopicsController < ApplicationController
  before_filter :login_required, :organization_required

  def index
    @topics = current_organization.topics
  end

  def create
    selected_emails = params[:selected_users].split(',')
    new_topic = Topic.create_topic(params[:title], params[:content], selected_emails, current_organization, login_user)
    EmailEngine::TopicNotifier.new(new_topic.id).create_topic_notification
    topics = current_organization.topics

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

  def archive
    detail_topic_id = params[:topic]

    if detail_topic_id.blank? # 判断是否在 topic detail 页面
      selected_topics_ids = params[:selected_topics_to_archive].split(',')
      Topic.find(selected_topics_ids).each { |topic| topic.archived_by(login_user) }
      topics = Topic.get_unarchived(login_user).all
      # 刷新 topic list
      render :json => {
                :update => {
                            "topic-list" => render_to_string(:partial => 'topics/topic_list',
                                                             :layout => false,
                                                             :locals => {
                                                                 :topics => topics
                                                            })
                          }
                      }
    else
      topic = Topic.find(detail_topic_id).archived_by(login_user)
      # 刷新 archive 按钮状态
      render :json => {
                :update => {
                            "archive-form" => render_to_string(:partial => 'topics/archive_form',
                                                               :layout => false,
                                                               :locals => {
                                                                   :topic => topic
                                                              })
                          }
                      }
    end
  end

  def unarchived
    @topics = Topic.get_unarchived(login_user).all
  end

  def add_tags
    detail_topic_id = params[:topic]

    if detail_topic_id.blank? # 判断是否在 topic detail 页面
      selected_topics_ids = params[:selected_topics_to_tagging].split(',')
      topics = Topic.find(selected_topics_ids).map { |topic| topic.add_tags(params[:tags]) }
      respond_array = []
      topics.each { |topic| respond_array << "tag-container-#{topic.id}" << render_to_string(:partial => 'tags/headline_tags',
                                                                             :layout => false,
                                                                             :locals => {
                                                                                 :topic => topic
                                                                           }) }
      # 刷新 topic list 页面中，选中的 topic 后的 tags
      render :json => { update: Hash[*respond_array] }

    else
      topic = Topic.find(detail_topic_id).add_tags(params[:tags])
      # 刷新 topic detail 页面中，topic title 后面的 tags
      render :json => {
                 :update => {
                             "tag-container-#{topic.id}" => render_to_string(:partial => 'tags/headline_tags',
                                                                             :layout => false,
                                                                             :locals => {
                                                                                 :topic => topic
                                                                           })
                            }
                      }
    end
  end

  def remove_tag
    topic = Topic.find(params[:topic]).remove_tag(params[:tag])

    render :json => {
               :update => {
                           "tag-container-#{topic.id}" => render_to_string(:partial => 'tags/headline_tags',
                                                                           :layout => false,
                                                                           :locals => {
                                                                               :topic => topic
                                                                         })
                          }
                    }
  end

  def filter_with_tag
    detail_topic_id = params[:topic]
    @topics = current_organization.topics.map { |topic| topic if topic.has_tag?(params[:tag]) }.reject { |t| t.blank? }

    if detail_topic_id.blank? # 判断是否在 topic detail 页面
      # 刷新 topic list
      render :json => {
                  :update => {
                              "topic-list" => render_to_string(:partial => 'topics/topic_list',
                                                               :layout => false,
                                                               :locals => {
                                                                   :topics => @topics
                                                              })
                            }
                        }
    else
      # 从 topic detail 页面 刷新至 topic list 页面
      render :json => {
                  :update => {
                              "topic-area" => render_to_string(:partial => 'topics/topic_area',
                                                               :layout => false,
                                                               :locals => {
                                                                   :topics => @topics,
                                                                   :topic => nil
                                                              })
                            }
                        }
    end
  end
end
