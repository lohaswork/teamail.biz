# encoding: utf-8
#TODO: update the cleaner
require 'spec_helper'
require 'helpers'

describe "the topics action" do
  include Helpers
  describe "user on topic list page" do
    context "user on the topic list page", :js => true do
      it  "should see the topic title" do
        user = create(:normal_user)
        organization = user.organization
        login_with(user.email, user.password)
        page.should have_content(user.email)
        visit organization_topics_path(organization)
        page.should have_content organization.topics.first.title
      end
    end

    context "user not login go the topic title list page" do
      it "should not see the topic title" do
        organization = create(:normal_user).organization
        visit organization_topics_path(organization)
        page.should_not have_content organization.topics.first.title
      end
    end

    context "not the organization user go to the topic list" do
      it "should not saw the topics title" do
        organization = create(:organization_with_topic, name:"new-organization")
        user = create(:normal_user)
        login_with(user.email, user.password)
        visit organization_topics_path(organization)
        page.should_not have_content organization.topics.last.title
      end
    end
  end

  describe "user create new topic", :js => true do
    before do
      @organization = create(:organization_with_multi_users)
      @user = @organization.users.first
      login_with(@user.email, @user.password)
      page.should have_content @user.email
      visit organization_topics_path(@organization)
    end

    describe "user can open a create topic field" do
      context "user click the new topic buttion" do
        it "should have a field for new topic" do
          page.should have_link "创建新话题"
          page.should_not have_selector "#new-topic-form"
          click_on "创建新话题"
          page.should have_selector "#new-topic-form"
        end

        it "should saw the user select checkbox" do
          page.should have_link "创建新话题"
          click_on "创建新话题"
          find('#select-user').should have_content(@organization.users.last.email_name)
        end

        it "should not have current user name in the select user checkbox" do
          page.should have_link "创建新话题"
          click_on "创建新话题"
          find('#select-user').should_not have_content(@user.email_name)
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

        it "should add the selected user into topic members" do
          click_on "创建新话题"
          fill_in "title", :with => "test title"
          find(:xpath, "(//input[@type='checkbox'])[10]").set(true)
          click_button "创建"
          page.should have_content "test title"
          @organization.topics.last.users.should include(@organization.users.last)
        end

        it "should default add the current user as member" do
          click_on "创建新话题"
          fill_in "title", :with => "test title"
          click_button "创建"
          page.should have_content "test title"
          @organization.topics.last.users.should include(@user)
        end

        it "should select all of the users by select all checkbox" do
          click_on "创建新话题"
          fill_in "title", :with => "test title"
          find(:xpath, "//input[@class='all']").set(true)
          click_button "创建"
          page.should have_content "test title"
          @organization.topics.last.users.size.should == @organization.users.size
        end
      end

      context "user create success with a discussion" do
        it "shold see the discussion size change" do
          click_on "创建新话题"
          fill_in "title", :with => "test title"
          fill_in "content", :with => "this is test discussion"
          click_button "创建"
          page.should have_content "test title"
          page.should have_content 1
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
      user = create(:normal_user)
      @organization = user.organization
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

    context "user create topic with blank content success" do
      it "should see the R.T for content" do
        click_on "创建新话题"
        fill_in "title", :with => "test title"
        click_button "创建"
        page.should have_content "test title"
        click_on @organization.topics.last.title
        page.should have_content "如题"
      end
    end
  end
  describe "go to discussion page with selected user", :js => true do
    before do
      @organization = create(:organization_with_multi_users)
      @user = @organization.users.first
      login_with(@user.email, @user.password)
      page.should have_content @user.email
      visit organization_topics_path(@organization)
    end

    context "user go to discussion page saw the select users" do
      it "should see the last discussion member default selected " do
        click_on "创建新话题"
        fill_in "title", :with => "test title"
        find(:xpath, "(//input[@type='checkbox'])[10]").set(true)
        click_button "创建"
        page.should have_content("test title")
        click_on "test title"
        find(:xpath, "(//input[@type='checkbox'])[10]").should be_checked
      end
    end

    describe "user create discussion with select user" do
      before do
        click_on "创建新话题"
        fill_in "title", :with => "test select user"
        click_button "创建"
        page.should have_content("test select user")
        click_on "test select user"
        page.should have_content("test select user")
      end

      context "select a user manully" do
        it "should add the user to the discussion" do
          fill_in "content", :with => "user create a discussion for discussion users"
          checkbox = find(:xpath, "(//input[@type='checkbox'])[10]")
          checkbox.set(true)
          click_button "回复"
          page.should have_content "user create a discussion for discussion users"
          Discussion.last.users.should include(User.find_by_email(checkbox.value))
        end

        it "should add the user to the topic member" do
          Topic.last.users.should_not include(@organization.users.last)
          fill_in "content", :with => "user create a discussion for topic users"
          checkbox = find(:xpath, "(//input[@type='checkbox'])[9]")
          checkbox.set(true)
          click_button "回复"
          page.should have_content "user create a discussion for topic users"
          Topic.last.users.should include(User.find_by_email(checkbox.value))
        end

        it "should add all users by select all" do
          Topic.last.users.size.should == 1
          fill_in "content", :with => "user create a discussion for topic users"
          checkbox = find(:xpath, "(//input[@class='all'])")
          checkbox.set(true)
          click_button "回复"
          page.should have_content "user create a discussion for topic users"
          Topic.last.users.size.should == 10
        end

        it "should add set the last created user as default checked" do
          fill_in "content", :with => "user create a discussion for discussion users"
          checkbox = find(:xpath, "(//input[@type='checkbox'])[10]")
          checkbox.set(true)
          click_button "回复"
          page.should have_content "user create a discussion for discussion users"
          find(:xpath, "(//input[@type='checkbox'])[10]").should be_checked
        end
      end
    end
  end
  describe "user on the own topics" do
    context "user not login in" do
      it "should redirect to the login page" do
        visit topics_path
        current_path.should == login_path
      end
    end

    describe "user already login" ,:js=>true do
      before do
        @user = create(:normal_user)
        login_with(@user.email, @user.password)
        page.should have_content @user.email
      end
      context "user go to topics page" do
        it "should have the topic title" do
          visit topics_path
          page.should have_content @user.topics.first.title
        end
      end

      context "user click on the navybar" do
        it "should have the topic title" do
          click_on "个人空间"
          page.should have_content @user.topics.first.title
        end
      end

    end
  end

  describe "user go to topic page with a invalid id" do
    it "should on the 404 page" do
      visit organization_topics_path('invalid_id')
      current_path.should == '/404.html'
    end
  end
end
