# encoding: utf-8
class TopicsController < ApplicationController
  def index
    organization_id = params[:organization_id]
    organization_id && update_current_organization(Organization.find(organization_id))
    @topics = current_organization && current_organization.topics
  end

  def create
    unless current_user && current_organization && Topic.create_topic(params[:title], current_organization.id, current_user.id)
      redirect_to root_path
    end
    topics = current_organization.topics
    render :json => {:update => {"topic-list" => render_to_string(:partial => 'topic_list.html', :layout => false, :locals => {:topics => topics})}}
  end
end
