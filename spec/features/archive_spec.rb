# encoding: utf-8
require 'spec_helper'
require 'helpers'

describe "archived topics have new discussion" do
  include Helpers
  describe "from himself", :js => true do
    before do
      @organization = create(:organization_with_multi_users)
      @user = @organization.users.first
      @another_user = @organization.users.last
      mock_login_with(@user.email)
      page.should have_content(@user.email)
      @topic = @organization.topics.first
      @topic.users << @another_user
      @topic.save
      @topic.archived_by(@user)
      @topic.archived_by(@another_user)
    end

    it "should have a topic archived already and archive button disabled" do
      @topic.user_topics.find_by_user_id(@user.id).archive_status.should eq(1)
      @topic.user_topics.find_by_user_id(@another_user.id).archive_status.should eq(1)
      visit topic_path(@topic)
      find('#archive-submit')[:disabled].should eq "disabled"
    end

    it "should see archive_status change when a new reply added" do
      visit topic_path(@topic)
      fill_in "content", :with => "user create a new discussion"
      click_button "回复"
      page.should have_content "user create a new discussion"
      @topic.user_topics.find_by_user_id(@user.id).archive_status.should eq(1)
      find('#archive-submit')[:disabled].should eq "disabled"
      @topic.user_topics.find_by_user_id(@another_user.id).archive_status.should_not eq(1)
    end

    it "visit unarchived topic detail page should see archive button clickable" do
      unarchived_topic = @organization.topics.last
      @user.topics << unarchived_topic
      @user.save
      visit topic_path(unarchived_topic)
      find('#archive-submit')[:disabled].should_not eq "disabled"
      unarchived_topic.user_topics.find_by_user_id(@user.id).archive_status.should_not eq(1)
      click_button 'archive-submit'
      sleep 0.01
      find('#archive-submit')[:disabled].should eq "disabled"
      unarchived_topic.user_topics.find_by_user_id(@user.id).archive_status.should eq(1)
    end
  end
end
