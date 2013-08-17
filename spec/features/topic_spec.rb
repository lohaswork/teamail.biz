# encoding: utf-8
require 'spec_helper'
require 'helpers'

describe "the topics action" do
  include Helpers
  describe "user on topic list page" do
    context "user on the topic list page", :js => true do
      it  "should see the topic title" do
        organization = create(:organization)
        user = organization.users.first
        login_with(user.email, user.password)
        page.should have_content(user.email)
        visit organization_topics_path(organization)
        page.should have_content organization.topics.first.title
      end
    end

    context "user not login go the topic title list page" do
      it "should not see the topic title" do
        organization = create(:organization)
        visit organization_topics_path(organization)
        page.should_not have_content organization.topics.first.title
      end
    end

    context "not the organization user go to the topic list" do
      it "should not saw the topics title" do
        organization = create(:organization)
        user = create(:already_activate_user)
        login_with(user.email, user.password)
        visit organization_topics_path(organization)
        page.should_not have_content organization.topics.first.title
      end
    end
  end

  describe "user create new topic", :js => true do
    before do
      organization = create(:organization)
      user = organization.users.first
      login_with(user.email, user.password)
      page.should have_content user.email
      visit organization_topics_path(organization)
    end

    describe "user can open a create topic field" do
      context "user click the new topic buttion" do
        it "should have a field for new topic" do
          page.should have_link "创建新话题"
          page.should_not have_selector "#new-topic-form"
          click_on "创建新话题"
          page.should have_selector "#new-topic-form"
        end
      end

      context "user reopen the field" do
        it "should keep the text" do
          click_on "创建新话题"
          fill_in "title", :with => "test title"
          click_on "取消"
          page.should_not have_link "取消"
          click_on "创建新话题"
          find_field('title').value == "test title"
        end
      end
    end

    describe "user create new topic" do
      context "user create success" do
        it "should see the new topic on the list" do
          click_on "创建新话题"
          fill_in "title", :with => "test title"
          click_button "创建"
          page.should have_content "test title"
          page.should_not have_selector "#new-topic-form"
        end
      end

      context "user create failed" do
        it "should see error message" do
          click_on "创建新话题"
          click_button "创建"
          page.should have_content "请输入标题"
        end
      end
    end
  end

  describe "user on topic detail page", :js => true do
    before do
      @organization = create(:organization)
      user = @organization.users.first
      login_with(user.email, user.password)
      page.should have_content(user.email)
      visit organization_topics_path(@organization)
    end

    context "click the topic title" do
      it "should go to the topic detail page" do
        click_on @organization.topics.first.title
        current_path.should == topic_path(@organization.topics.first)
        page.should have_content @organization.topics.first.discussions.first.content
      end
    end

    context "user create a new discussions" do
      it "should see the content on the page" do
        visit topic_path(@organization.topics.first)
        fill_in "content", :with => "user create a discussion"
        click_button "回复"
        page.should have_content "user create a discussion"
      end
    end

    context "user fill in nothing for discussion" do
      it "should see the error message" do
        visit topic_path(@organization.topics.first)
        click_button "回复"
        page.should have_content "请输入回复内容"
      end
    end
  end
end
