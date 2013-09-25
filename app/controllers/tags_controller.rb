class TagsController < ApplicationController
  before_filter :access_organization

  def create
    organization = current_organization
    tag_name = params[:tag_name].strip
    tags = Tag.create_with_organization(tag_name, organization)

    render :json => {
              :update => {
                "tag-list" => render_to_string(:partial => 'tags/tag_list',
                                               :layout => false,
                                               :locals => {
                                                 :tags => tags
                                              })
                        }
                    }
  end

  def add
    # uniq need refactor
    # 更换数据操作的方法
    # 更换topics取得的方法，使得个人空间也适用
    selected_topics_ids = params[:selected_topics].split(',').uniq
    topics = current_organization.topics_add_taggings(selected_topics_ids, params[:tags])
    topics = current_organization.topics

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

  def remove
    # 更换数据操作的方法
    # 更换topics取得的方法，使得个人空间也适用
    Topic.find(params[:topic_id]).remove_tagging(params[:id])
    topics = current_organization.topics

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
end
