# encoding: utf-8
require 'spec_helper'
require 'helpers'

describe "topic section" do
  include Helpers
  describe "user login with organization", :js => true do
    before do
      user = create(:normal_user)
      @organization = user.default_organization
      login_with(user.email, user.password)
      page.should have_content user.email
      visit topics_path
    end

    context "in the topic list page, select topics and tags, click 应用 button" do
      before do
        # topics should not have any tags before this
        find(:css, "div#select-topic").should_not have_content @organization.tags.first.name
        first(:css, "div#select-topic input[type='checkbox']").set(true)
        click_button "tagging-dropdown"
        first(:css, "div#tag-list input[type='checkbox']").set(true)
        click_button "应用"
      end

      it "should see already exist tags attached to the selected topics" do
        find(:css, "div#select-topic").should have_content @organization.tags.first.name
      end

      it "click delete tagging link, should not see the attached tag" do
        remove_tag_link = find(:css, "a.tag-remove-link")
        remove_tag_link.click
        find(:css, "div#select-topic").should_not have_content @organization.tags.first.name
      end
    end

    context "in the topic list page, not select topic, click the tagging-group control" do
      it  "should not see the organization tags" do
        find('#tagging-dropdown')[:disabled].should eq "disabled"
      end
    end

    context "in the topic list page, select some topics, click the tagging-group control" do
      before do
        first(:css, "div#select-topic input[type='checkbox']").set(true)
        click_button "tagging-dropdown"
      end

      it  "should see the organization tags and should not see 应用 button" do
        page.should have_content @organization.tags.last.name
        page.should_not have_selector(:css, "#tagging-submit")
        page.should_not have_button "应用"
      end

      it "should not see 新建 button when tags are selected" do
        first(:css, "div#tag-list input[type='checkbox']").set(true)
        page.should_not have_selector(:css, "#tag-submit")
        page.should_not have_button "新建"
        page.should have_selector(:css, "#tagging-submit")
        page.should have_button "应用"
      end

      it "should not see 应用 button when selections are canceled" do
        first(:css, "div#tag-list input[type='checkbox']").set(true)
        page.should_not have_selector(:css, "#tag-submit")
        page.should_not have_button "新建"
        page.should have_selector(:css, "#tagging-submit")
        page.should have_button "应用"
        first(:css, "div#tag-list input[type='checkbox']").set(false)
        page.should have_selector(:css, "#tag-submit")
        fill_in "tag_name", :with => "新标签"
        page.should have_button "新建"
        page.should_not have_selector(:css, "#tagging-submit")
        page.should_not have_button "应用"
      end

      it "should see the newly created tag", :js => true do
        fill_in "tag_name", :with => "新标签"
        click_button "新建"
        find(:css, "div#tag-list").should have_content "新标签"
        find(:css, "div#tag-filters").should have_content "新标签"
      end

      it "should be able to create tags with upper-case name & down-case name", :js => true do
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

  describe "left bar", :js => true do
    before do
      user = create(:normal_user)
      @organization = user.default_organization
      login_with(user.email, user.password)
      page.should have_content user.email
      visit topics_path
      specific_tag = @organization.tags.first
      specific_topic = @organization.topics.first
      specific_topic.tags << specific_tag
    end

    it "should see all organization tags" do
      find(:css, "div#tag-filters").should have_content @organization.tags.first.name
      find(:css, "div#tag-filters").should have_content @organization.tags.last.name
    end

    it "filter using tags and topics under the tag show" do
      link = all(:css, "div#tag-filters :link").first
      link.click
      page.should have_content @organization.topics.first.title
      page.should_not have_content @organization.topics.last.title
    end

    it "filter using tags when no topic shows" do
      link = all(:css, "div#tag-filters :link").last
      link.click
      page.should_not have_css("div.topic-headline")
    end

    it "click tag and it turns active and others become inactive" do
      first_link = all(:css, "div#tag-filters :link").first
      last_link = all(:css, "div#tag-filters :link").last
      first_link.click
      all(:css, "div#tag-filters li").first.should have_css(":link.active-tag")
      last_link.click
      all(:css, "div#tag-filters li").last.should have_css(":link.active-tag")
      all(:css, "div#tag-filters li").first.should_not have_css(":link.active-tag")
    end
  end
end
