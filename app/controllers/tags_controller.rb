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
    topics = current_organization.topics.map do |topic|
      topic.add_taggings(params[:tags]) if params[:selected_topics].split(',').uniq.include? topic.id
    end

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
