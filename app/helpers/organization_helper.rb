module OrganizationHelper
  def default_display_tags
    current_organization.tags.visible.order("convert(name USING GBK)")
  end

  def organizations_other_than_current
    login_user.organizations.reject { |organization| organization == current_organization }
  end
end
