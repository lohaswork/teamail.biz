class TagsController < ApplicationController
  before_filter :access_organization

  def create
    @organization = Organization.find(current_organization.id)
    tag_name = params[:tag_name].strip
    tag = Tag.create_with_organization(tag_name, @organization)

    render :json => {
              :update => {
                "tag-list" => render_to_string(:partial => 'tags/tag_list',
                                              :layout => false,
                                              :locals => {
                                                :tags => @organization.tags
                                              })
                        }
                    }
  end

  def add
    selected_taggs_ids = params[:tags[]]
    selected_topics_ids = params[:topics[]]
    #@topics = selected_topics_ids.each {|topic_id| Topic.find(topic_id).add_taggings(selected_taggs_ids) }
    @topics = Topic.find(selected_topics_ids.split(',')).add_taggings(selected_taggs_ids)

    render :json => {
              :update => {
                "topic-list" => render_to_string(:partial => 'topics/topic_list',
                                              :layout => false,
                                              :locals => {
                                                :topics => @topics
                                              })
                        }
                    }
  end
end
