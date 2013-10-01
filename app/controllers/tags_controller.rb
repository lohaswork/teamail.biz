class TagsController < ApplicationController
  before_filter :access_organization

  def create
    tag_name = params[:tag_name].strip
    tags = current_organization.add_tag(tag_name).tags

    render :json => {
              :update => {
                "tag-list" => render_to_string(:partial => 'tags/tag_list',
                                               :layout => false,
                                               :locals => {
                                                   :tags => tags
                                              }),
                "tag-filters" => render_to_string(:partial => 'tags/tag_filters',
                                                  :layout => false,
                                                  :locals => {
                                                      :tags => tags
                                              })
                        }
                    }
  end
end
