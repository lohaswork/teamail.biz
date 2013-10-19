# encoding: utf-8
require 'spec_helper'
require 'helpers'

describe "topics have new discussion" do
  include Helpers
  before do
      @organization = create(:organization_with_multi_users)
      @user = @organization.users.first
      @another_user = @organization.users.last
      mock_login_with(@user.email)
      page.should have_content(@user.email)
      @topic = @organization.topics.first
      @topic.users << @another_user
      @topic.discussions.last.users << @user
      @topic.save
  end

  describe "archive_feature", :js => true do
    before do
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
      # Wait for page loading, need refactor later
      sleep 0.1
      find('#archive-submit')[:disabled].should eq "disabled"
      unarchived_topic.user_topics.find_by_user_id(@user.id).archive_status.should eq(1)
    end
  end

  describe "read_status_feature", :js => true do
    it "should see unread topics in personal_topics_path" do
      visit personal_topics_path
      page.should have_content @user.topics.first.title
      page.should have_css('div.unread')
      page.should_not have_css('div.read')
    end

    it "should see unread topics in personal_topics_inbox_path" do
      visit personal_topics_inbox_path
      page.should have_content @user.topics.first.title
      page.should have_css('div.unread')
      page.should_not have_css('div.read')
    end

    it "should becomes read after visit topic detail page" do
      unread_num = @user.topics.length
      find(:css,"div.personal-inbox").should have_content unread_num.to_s
      visit personal_topics_path
      click_on @user.topics.first.title
      page.should have_content @user.topics.first.title
      click_on "未处理"
      page.should have_css('div.read')
      find(:css,"div.personal-inbox").should have_content (unread_num - 1).to_s
    end

    it "should be unread for other users when a new topic created" do
      visit personal_topics_path
      click_on "创建新话题"
      fill_in "title", :with => "test title"
      checkbox = find(:xpath, "(//div[@id='select-user']//input[@type='checkbox'])[10]")
      checkbox.set(true)
      click_button "创建"
      page.should have_content "test title"
      topic = @user.topics.last
      topic.read_status_of(@user).should eq(1)
      topic.read_status_of(@another_user).should_not eq(1)
    end

    it "should change read status when add a discussion to the read topic" do
      @topic.discussions.last.mark_as_read_by(@another_user)
      visit topic_path(@topic)
      fill_in "content", :with => "discussion from user himself"
      click_button "回复"
      page.should have_content "discussion from user himself"
      @topic.read_status_of(@user).should eq(1)
      @topic.read_status_of(@another_user).should_not eq(1)
    end
  end
end