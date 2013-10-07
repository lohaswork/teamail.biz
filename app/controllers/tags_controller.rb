class TagsController < ApplicationController
  before_filter :login_required, :organization_required
  before_filter :access_organization, :only => [:create]

  def create
    tag_name = params[:tag_name].strip
    tags = Organization.find(params[:organization_id]).add_tag(tag_name).tags

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
