# encoding: utf-8
require 'spec_helper'
require 'helpers'

describe "member manage page", :js => true do
  include Helpers
  before do
    @organization = create(:organization_with_multi_users)
    @user = @organization.users.first
    @new_member = create(:clean_user)
    @new_member.update_attribute(:email, "new@new.com")
    login_with(@user.email, @user.password)
    page.should have_content(@user.email)
    visit show_member_path
    page.should have_content @user.email_name
  end

  it "should see colleagues email_name" do
    page.should have_content @organization.users.last.email_name
  end

  describe "as the admin of the organization" do
    before do
      OrganizationMembership.current_pair(@user, @organization).first.update_attribute(:authority_type, 1)
      visit show_member_path
    end

    it "should see 删除用户 button next to colleagues'name" do
      page.should have_content "删除该成员"
    end

    it "should see 邀请 button" do
      page.should have_button "邀请"
    end

    it "delete member action" do
      kicked_user = @organization.users.last
      page.should have_content kicked_user.email_name
      all(:css, ".member-container a").last.click
      page.should_not have_content kicked_user.email_name
      @organization.users.include?(kicked_user).should eq(false)
    end

    it "invite using invalid email address" do
      fill_in "user_email", :with => "test"
      click_button "邀请"
      page.should_not have_content "test@test.com"
      page.should have_content "邮件地址不合法"
    end

    #it "invite an exist user" do
    #  fill_in "user_email", :with => "new@new.com"
    #  click_button "邀请"
    #  page.should have_content "new@new.com"
    #  User.find_by_email("new@new.com").active_status.should eq(1)
    #end

    it "invite a non-exist user" do
      fill_in "user_email", :with => "test@test.com"
      click_button "邀请"
      page.should have_content "test@test.com"
      User.find_by_email("test@test.com").active_status.should_not eq(1)
    end
  end
end
