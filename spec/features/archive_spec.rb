# encoding: utf-8
require 'spec_helper'
require 'helpers'

describe "archived topics have new discussion" do
  include Helpers
  describe "from himself", :js => true do
    before do
      organization = create(:organization_with_multi_users)
      @user =  organization.users.first
      @another_user = organization.users.last
      @topic = create(:topic)
      organization.topics << @topic
      organization.save
      @topic.users << @user
      @topic.users << @another_user
      @topic.save
      @topic.archived_by(@user)
      @topic.archived_by(@another_user)
      mock_login_with(@user.email)
      debugger
      page.should have_content(@user.email)
    end

    it "should have a topic archived already" do
      @topic.user_topics.find_by_user_id(@user.id).archive_status.should eq(1)
      @topic.user_topics.find_by_user_id(@another_user.id).archive_status.should eq(1)
    end

    it "should still be archived when user replies himself" do
      visit topic_path(@topic)
      fill_in "content", :with => "user create a new discussion"
      click_button "回复"
      page.should have_content "user create a new discussion"
      @topic.user_topics.find_by_user_id(@user.id).archive_status.should eq(1)
      @topic.user_topics.find_by_user_id(@another_user.id).archive_status.should_not eq(1)
    end
  end
end
