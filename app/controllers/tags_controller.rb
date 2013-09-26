class TagsController < ApplicationController
  before_filter :access_organization

  def create
    # Organization find by refactor
    organization = current_organization
    tag_name = params[:tag_name].strip
    tags = organization.add_tag(tag_name).tags

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
end
