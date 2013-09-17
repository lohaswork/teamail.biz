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

    context "in the topic list page, click the tagging-group control", :js => true do
      it  "should see the organization tags" do
        click_button "tagging-dropdown"
        # Need to replace page with specific div
        page.should have_content @organization.tags.last.name
      end

      it "should see the newly created tag", :js => true do
        click_button "tagging-dropdown"
        fill_in "tag_name", :with => "新标签"
        click_button "新建"
        page.should have_content "新标签"
      end
    end
  end
end
