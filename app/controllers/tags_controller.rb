class TagsController < ApplicationController
  before_filter :login_required, :organization_required

  def create
    tag_name = params[:tag_name].strip
    tags = current_organization.add_tag(tag_name).tags.visible

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

  def hide
    tag = Tag.find params[:id]
    tag.update_attribute(:hide_status, true)
    tags = current_organization.tags.visible

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
