# encoding: utf-8
require 'spec_helper'
require 'helpers'

describe "the topics action" do
  include Helpers
  context "user on the topic list page", :js => true do
    it  "should see the topic title" do
      organization = create(:organization)
      user = organization.users.first
      login_with(user.email, user.password)
      page.should have_content(user.email)
      visit topics_path(organization_id:organization.id)
      page.should have_content organization.topics.first.title
    end
  end

  context "user not login go the topic title list page" do
    it "should not see the topic title" do
      organization = create(:organization)
      visit topics_path(organization_id:organization.id)
      page.should_not have_content organization.topics.first.title
    end
  end

  context "not the organization user go to the topic list" do
    it "should not saw the topics title" do
      organization = create(:organization)
      user = create(:already_activate_user)
      login_with(user.email, user.password)
      visit topics_path(organization_id:organization.id)
      page.should_not have_content organization.topics.first.title
    end
  end
end
