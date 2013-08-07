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
        visit organization_topics_path(organization_id:organization.id)
        page.should have_content organization.topics.first.title
      end
    end

    context "user not login go the topic title list page" do
      it "should not see the topic title" do
        organization = create(:organization)
        visit organization_topics_path(organization_id:organization.id)
        page.should_not have_content organization.topics.first.title
      end
    end

    context "not the organization user go to the topic list" do
      it "should not saw the topics title" do
        organization = create(:organization)
        user = create(:already_activate_user)
        login_with(user.email, user.password)
        visit organization_topics_path(organization_id:organization.id)
        page.should_not have_content organization.topics.first.title
      end
    end
  end

  describe "user create new topic", :js => true do
    before do
      @organization = create(:organization)
      @user = @organization.users.first
      login_with(@user.email, @user.password)
    end

    describe "user can open a create topic field" do
      context "user click the new topic buttion" do
        it "should have a field for new topic" do
          visit organization_topics_path(organization_id:@organization.id)
          page.should have_link "创建新话题"
        end
      end
    end
  end
end
