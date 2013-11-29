# encoding: utf-8
class TopicsController < ApplicationController
  include TextRegexp::TopicAnalysis
  before_filter :login_required, :organization_required

  def index
    @topics = current_organization.topics.order_by_update.page(params[:page])
  end

  def create
    selected_emails = params[:selected_emails] || []
    invited_emails = params[:invited_emails].split(/[\,\;]/).map { |email| email.strip.downcase }

    # Validate invite emails and add member by emails and send invitation emails at meantime
    add_member_from_discussion(invited_emails)

    # Get discussion notify party by add invited_emails and selected_emails,
    #   then send discussion notifications
    selected_emails = selected_emails.concat(invited_emails).uniq

    # Analyze title to sperate tags and real title
    email_title = params[:title]
    title, tags = analyzed_title email_title unless email_title.blank?
    new_topic = Topic.create_topic(title, email_title, params[:content], selected_emails, current_organization, login_user)
    add_tags_from_title(new_topic, tags)
    TopicNotifierWorker.perform_async(new_topic.id, selected_emails)

    render :json => { :reload => true }
    flash[:notice] = "邮件创建成功"
  end

  def show
    @topic = Topic.find(params[:id])
    @topic.discussions.last.mark_as_read_by(login_user)
    @discussions = @topic.discussions
  end

  def archive
    detail_topic_id = params[:topic]

    if detail_topic_id.blank? # 判断是否在 topic detail 页面
      selected_topics_ids = params[:selected_topics_to_archive].split(',')
      Topic.find(selected_topics_ids).each { |topic| topic.archived_by(login_user) }
      topics = Topic.get_unarchived(login_user).order_by_update.page(params[:page])
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
      # 返回收件箱列表
      render :json => { :status => "success", :redirect => personal_topics_inbox_path }
    end
  end

  def unarchived
    @topics = Topic.get_unarchived(login_user).order_by_update.page(params[:page])
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

  def filter_with_tags
    detail_topic_id = params[:topic]
    @topics = current_organization.topics.order_by_update.map { |topic| topic if topic.has_tags?(params[:tags].to_a) }.reject { |t| t.blank? }
    @topics = Kaminari.paginate_array(@topics).page(params[:page])

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

  def get_unread_number_of_unarchived_topics
    number = Topic.get_unarchived(login_user).to_a.reject { |topic| topic.read_status_of(login_user) == 1 }.length
    render :text => number
  end
end
