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
  end
end
