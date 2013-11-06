# encoding: utf-8
require 'spec_helper'
require 'helpers'
describe "organization member page" do
  # 分为4个模块: invite user, delete_member, user without an organization login, user have other organizations
  include Helpers

  let(:organization) { create(:organization_with_multi_users) }
  let(:user) { organization.users.first }
  let(:new_member) { create(:clean_user) }

  describe "invite user" do
    before do
      mock_login_with(user.email)
      page.should have_content(user.email)
      visit show_member_path
      page.should have_content user.email_name
    end

    context "as the admin of the organization" do
      before do
        organization.membership(user).update_attribute(:authority_type, 1)
        visit show_member_path
      end

      # 已激活用户能看到email_name
      it "should see activated colleagues email_name" do
        organization.users.each do |user|
          page.should have_content user.email_name
        end
      end

      it "should see 邀请 button" do
        page.should have_button "邀请"
      end

      it "invite using invalid email address", :js => true do
        fill_in "user_email", :with => "test"
        click_button "邀请"
        page.should_not have_content "test@test.com"
        page.should have_content "邮件地址不合法"
      end

      # 邀请后，未激活用户仅能看到email地址，不另外测试
      it "invite an exist user, should see email_name", :js => true do
        fill_in "user_email", :with => new_member.email
        click_button "邀请"
        page.should have_content new_member.email_name
        User.find_by_email(new_member.email).active_status.should eq(1)
      end

      it "invite a non-exist user, should see email_address", :js => true do
        fill_in "user_email", :with => "test@test.com"
        click_button "邀请"
        page.should have_content "test@test.com"
        User.find_by_email("test@test.com").active_status.should_not eq(1)
      end
    end

    context "non-admin user" do
      it "should see activated colleagues email_name & not see 邀请 button" do
        organization.users.each do |user|
          page.should have_content user.email_name
        end
        page.should_not have_button "邀请"
      end
    end
  end

  describe "delete member" do
    before do
      mock_login_with(user.email)
      page.should have_content(user.email)
      visit show_member_path
      page.should have_content user.email_name
    end

    context "as the admin of the organization", :js => true do
      let(:kicked_user) { organization.users.last }
      before do
        organization.membership(user).update_attribute(:authority_type, 1)
        visit show_member_path
        page.should have_content kicked_user.email_name
        all(:css, ".member-name a").last.click
      end

      it "should see 删除用户 button next to colleagues'name" do
        page.should have_content "删除该成员"
      end

      it "delete member action" do
        page.should_not have_content kicked_user.email_name
        Organization.find(organization.id).users.to_a.include?(kicked_user).should eq(false)
      end

      it "create new topic should not see kicked_user in notifier list" do
        visit organization_topics_path
        click_on "创建新话题"
        find(:css, "div#select-user-for-topic").should_not have_content kicked_user.email_name
      end
    end

    context "non-admin user" do
      it "should see activated colleagues email_name & not see 删除 button" do
        page.should have_content organization.users.last.email_name
        page.should_not have_content "删除该成员"
      end
    end
  end

  describe "user without an organization" do
    let(:user) { create(:clean_user) }
    before do
      login_with(user.email, user.password)
      page.should have_content(user.email)
      page.should have_content "请联系团队管理员，让您回到组织怀抱。"
    end

    it "visit topics path should redirect to no_organizations_path" do
      visit personal_topics_path
      page.should have_content "请联系团队管理员，让您回到组织怀抱。"
    end

    it "visit organization topics path should redirect to no_organizations_path" do
      visit organization_topics_path
      current_path.should == no_organizations_path
    end
  end
end
