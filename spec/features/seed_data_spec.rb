# encoding: utf-8
require 'spec_helper'
require 'helpers'
describe "user signup with seed data", :js => true do
  # 分为4个模块: invite user, delete_member, user without an organization login, user have other organizations
  include Helpers

  before do
    sign_up_with('user@example.com', 'password', 'company')
    page.should have_content '您已成功注册并创建了您的公司或团体'
    user = User.find_by_email 'user@example.com'
    user.update_attribute(:active_status, true)
  end

  it "login in can see seed tags and manual topic" do
    login_with('user@example.com', 'password')
    page.should have_content "如何使用teamail进行项目管理"
    within(:xpath, "//div[@id='tag-filters']") do
      page.should have_content "示例项目"
      page.should have_content "任务"
    end
  end
end
