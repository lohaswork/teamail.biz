# encoding: utf-8
class TopicsController < ApplicationController
  def index
    organization_id = params[:organization_id]
    organization_id && update_current_organization(Organization.find(organization_id))
    @topics = current_organization && current_organization.topics
  end
end
