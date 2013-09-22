# encoding: utf-8
require 'spec_helper'
require 'helpers'

describe "topic section" do
  include Helpers
  describe "user login with organization", :js => true do
    before do
      @organization = create(:organization_with_multi_users)
      @user = @organization.users.first
      login_with(@user.email, @user.password)
      page.should have_content @user.email
      visit organization_topics_path(@organization)
    end

    context "in the topic list page, click the tagging-group control" do
      before {click_button "tagging-dropdown"}
      it  "should see the organization tags" do
        page.should have_content @organization.tags.last.name
      end

      it "should see the newly created tag", :js => true do
        fill_in "tag_name", :with => "新标签"
        click_button "新建"
        page.should have_content "新标签"
      end

      it "cannot create same tag twice", :js => true do
        fill_in "tag_name", :with => "同一个标签"
        click_button "新建"
        page.should have_content "同一个标签"
        fill_in "tag_name", :with => "同一个标签"
        click_button "新建"
        page.should have_content "标签名已使用"
      end

      it "cannot create blank tag", :js => true do
        fill_in "tag_name", :with => " "
        click_button "新建"
        page.should have_content "标签名不能为空"
      end

      it "cannot create tag with mark other than dash and underscore", :js => true do
        fill_in "tag_name", :with => "错误%标签"
        click_button "新建"
        page.should have_content "名称不合法"
      end
    end
  end
end