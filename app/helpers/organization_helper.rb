module OrganizationHelper
  def default_display_tags
    current_organization.tags.visible.order("convert(name USING GBK)")
  end
end
