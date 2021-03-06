# encoding: utf-8
require 'spec_helper'
require 'helpers'

describe "topic section" do
  include Helpers
  describe "user in topic list page", :js => true do
    before do
      user = create(:normal_user)
      @organization = user.default_organization
      login_with(user.email, user.password)
      page.should have_content '退出'
      visit organization_topics_path
    end

    context "select topics and tags, click 应用 button" do
      before do
        # topics should not have any tags before this
        find(:css, "div#select-topic").should_not have_content @organization.tags.first.name
        find(:xpath, "//*[@id='select-topic']/ul/li[1]/div[1]/input").set(true)
        click_button "tagging-dropdown"
        @checkbox = find(:xpath, "(//*[@id='tag-list']//input[@type='checkbox'])[1]")
        @checkbox.set(true)
        click_button "应用"
      end

      it "should see already exist tags attached to the selected topics" do
        find(:css, "div#select-topic").should have_content Tag.find(@checkbox.value).name
      end

      it "click delete tagging link, should not see the attached tag" do
        remove_tag_link = find(:css, "a.tag-remove-link")
        remove_tag_link.click
        find(:css, "div#select-topic").should_not have_content Tag.find(@checkbox.value).name
      end
    end

    context "not select topic, click the tagging-group control" do
      it  "should not see the organization tags" do
        find('#tagging-dropdown')[:disabled].should eq "disabled"
      end
    end

    context "select some topics, click the tagging-group control" do
      before do
        find(:xpath, "//*[@id='select-topic']/ul/li[1]/div[1]/input").set(true)
        click_button "tagging-dropdown"
      end

      it  "should see the organization tags and should not see 应用 button" do
        page.should have_content @organization.tags.last.name
        page.should_not have_selector(:css, "#tagging-submit")
        page.should_not have_button "应用"
      end

      it "should not see 新建 button when tags are selected" do
        find(:xpath, "(//*[@id='tag-list']//input[@type='checkbox'])[1]").set(true)
        page.should_not have_selector(:css, "#tag-submit")
        page.should_not have_button "新建"
        page.should have_selector(:css, "#tagging-submit")
        page.should have_button "应用"
      end

      it "should not see 应用 button when selections are canceled" do
        find(:xpath, "(//*[@id='tag-list']//input[@type='checkbox'])[1]").set(true)
        page.should_not have_selector(:css, "#tag-submit")
        page.should_not have_button "新建"
        page.should have_selector(:css, "#tagging-submit")
        page.should have_button "应用"
        find(:xpath, "(//*[@id='tag-list']//input[@type='checkbox'])[1]").set(false)
        page.should have_selector(:css, "#tag-submit")
        fill_in "tag_name", :with => "新标签"
        page.should have_button "新建"
        page.should_not have_selector(:css, "#tagging-submit")
        page.should_not have_button "应用"
      end

      it "should see the newly created tag" do
        fill_in "tag_name", :with => "新标签"
        click_button "新建"
        find(:css, "div#tag-list").should have_content "新标签"
        find(:css, "div#tag-filters").should have_content "新标签"
      end

      it "should be able to create tags with upper-case name & down-case name" do
        fill_in "tag_name", :with => "ABCTag"
        click_button "新建"
        page.should have_content "ABCTag"
        fill_in "tag_name", :with => "abcTag"
        click_button "新建"
        page.should have_content "abcTag"
      end

      it "should disable the create button when nothing inputs" do
        fill_in "tag_name", :with => ""
        find('#tag-submit')[:disabled].should eq "disabled"
      end

      it "cannot create same tag twice" do
        fill_in "tag_name", :with => "同一个标签"
        click_button "新建"
        page.should have_content "同一个标签"
        fill_in "tag_name", :with => "同一个标签"
        click_button "新建"
        page.should have_content "标签名已使用"
      end

      it "cannot create blank tag" do
        fill_in "tag_name", :with => " "
        click_button "新建"
        page.should have_content "标签名不能为空"
      end
    end
  end

  describe "user in topic detail page", :js => true do
    before do
      @user = create(:normal_user)
      @organization = @user.default_organization
      topic_id = @user.topics.first.id
      login_with(@user.email, @user.password)
      page.should have_content "退出"
      visit topic_path(topic_id)
    end

    it  "should be able to click tagging-dropdown button" do
      find('#tagging-dropdown')[:disabled].should_not eq "disabled"
    end

    it "should see already exist tag name" do
      tag = create(:tag)
      topic = @user.topics.first
      topic.tags << tag
      topic.save
      visit topic_path(topic)
      find(:css, "div.topic-show").should have_content tag.name
    end

    context "select topics and tags, click 应用 button" do
      before do
        # topic should not have any tags before this
        click_button "tagging-dropdown"
        find(:xpath, "(//div[@id='tag-list']//input[@type='checkbox'])[1]").set(true)
        find(:xpath, "(//div[@id='tag-list']//input[@type='checkbox'])[2]").set(true)
        click_button "应用"
      end

      it "should see already exist tags attached to the selected topics" do
        find(:css, "div.topic-show").should have_content @organization.tags[0].name
        find(:css, "div.topic-show").should have_content @organization.tags[1].name
      end

      it "click delete tagging link, should not see the attached tag" do
        find(:xpath, "(//a[@class='tag-remove-link'])[1]").click
        find(:css, "div.topic-show").should_not have_content @organization.tags[0].name
        find(:css, "div.topic-show").should have_content @organization.tags[1].name
      end

    end
  end

  describe "left bar", :js => true do
    before do
      user = create(:normal_user)
      @organization = user.default_organization
      login_with(user.email, user.password)
      page.should have_content '退出'
    end

    context "topic list page filter" do
      before do
        specific_tag = @organization.tags.first
        specific_topic = @organization.topics.first
        specific_topic.tags << specific_tag
        visit organization_topics_path
      end

      it "click 管理标签 will toggle tag manage page" do
        click_button "管理标签"
        find(:css, "div#tag-filters").should have_content "隐藏"
        click_button "管理标签"
        find(:css, "div#tag-filters").should_not have_content "隐藏"
      end

      it "click 管理标签 and then click link 隐藏, will see tag disapear" do
        click_button "管理标签"
        find(:css, "div#tag-filters").should have_content @organization.tags.first.name
        tag = find(:xpath, "(//div[@id='tag-filters']//li)[1]")
        tag.should have_content "隐藏"
        within(:xpath, "(//div[@id='tag-filters']//li)[1]") do
          click_on "隐藏"
        end
        find(:css, "div#tag-filters").should_not have_content @organization.tags.first.name
        # Implies still at manage tag page
        find(:css, "div#tag-filters").should have_content "隐藏"
      end

      it "should see all organization tags" do
        find(:css, "div#tag-filters").should have_content @organization.tags.first.name
        find(:css, "div#tag-filters").should have_content @organization.tags.last.name
      end

      it "filter using tag and should see topic list refreshed" do
        link = all(:css, "div#tag-filters li").first
        link.click
        wait_for_ajax
        page.should have_content @organization.topics.first.title
        page.should_not have_content @organization.topics.last.title
      end

      it "filter using tag that does not have any topics should not see any topics" do
        link = all(:css, "div#tag-filters li").last
        link.click
        page.should_not have_css("div.topic-row")
      end

      #it "click two tags and they both turn active" do
      #  first_link = all(:css, "div#tag-filters li").first
      #  last_link = all(:css, "div#tag-filters li").last
      #  first_link.click
      #  all(:css, "div#tag-filters li.active-tag").length.should eq 1
      #  last_link.click
      #  all(:css, "div#tag-filters li.active-tag").length.should eq 2
      #end
    end

    context "topic detail page filter" do
      before do
        specific_tag = @organization.tags.first
        specific_topic = @organization.topics.first
        specific_topic.tags << specific_tag
        visit topic_path(specific_topic)
      end

      it "should see all organization tags" do
        find(:css, "div#tag-filters").should have_content @organization.tags.first.name
        find(:css, "div#tag-filters").should have_content @organization.tags.last.name
      end

      it "filter using tag and should see topic list refreshed" do
        within(:xpath, "//div[@id='tag-filters']") do
          find('li', :text => @organization.tags.first.name).click
        end
        wait_for_ajax
        page.should have_content @organization.topics.first.title
        page.should_not have_content @organization.topics.last.title
      end

      it "filter using tag that does not have any topics should not see any topics" do
        within(:xpath, "//div[@id='tag-filters']") do
          find('li', :text => @organization.tags.last.name).click
        end
        page.should_not have_css("div.topic-row")
      end

      #it "click two tags and they both turn active" do
      #  first_link = all(:css, "div#tag-filters li").first
      #  last_link = all(:css, "div#tag-filters li").last
      #  first_link.click
      #  all(:css, "div#tag-filters").first.should have_css("li.active-tag")
      #  last_link.click
      #  all(:css, "div#tag-filters").last.should have_css("li.active-tag")
      #  all(:css, "div#tag-filters").first.should have_css("li.active-tag")
      #end
    end
  end

  describe "user in unarchived topic list page", :js => true do
    before do
      user = create(:normal_user)
      @organization = user.default_organization
      # create an topic that not belongs to user's inbox
      @unrelated_topic = create(:topic)
      another_user = create(:clean_user)
      discussion = create(:discussion, user_from: another_user.id, discussable: @unrelated_topic)
      @organization.topics << @unrelated_topic
      @organization.users << another_user
      # login
      login_with(user.email, user.password)
      page.should have_content '退出'
      visit personal_topics_inbox_path
    end

    context "select topics and tags, click 应用 button" do
      before do
        # topics should not have any tags before this
        find(:css, "div#select-topic").should_not have_content @organization.tags.first.name
        first(:css, "div#select-topic input[type='checkbox']").set(true)
        click_button "tagging-dropdown"
        first(:css, "div#tag-list input[type='checkbox']").set(true)
        click_button "应用"
      end

      it "should see unrelated_topic in organization_topics_path" do
        visit organization_topics_path
        find(:css, "div#select-topic").should have_content @unrelated_topic.title
      end

      it "should see already exist tags attached to the selected topics" do
        find(:css, "div#select-topic").should have_content @organization.tags.first.name
        find(:css, "div#select-topic").should_not have_content @unrelated_topic.title
      end

      it "click delete tagging link, should not see the attached tag" do
        remove_tag_link = find(:css, "a.tag-remove-link")
        remove_tag_link.click
        find(:css, "div#select-topic").should_not have_content @organization.tags.first.name
      end
    end
  end
end
