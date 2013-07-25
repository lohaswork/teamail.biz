# encoding: utf-8
class TopicsController < ApplicationController
  # before_filter :require_authenticate
  def index
    organization_id = params[:organization_id]
    current_organization =  organization_id && Organization.find(organization_id)
    @topics = current_organization && current_organization.topics
  end
end
