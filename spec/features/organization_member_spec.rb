# encoding: utf-8
require 'spec_helper'
require 'helpers'
describe "organization member page" do
  # 分为4个模块: invite user, delete_member, user without an organization login, user have other organizations
  include Helpers
  describe "invite user", :js => true do
    before do
      @organization = create(:organization_with_multi_users)
      @user = @organization.users.first
      @new_member = create(:clean_user)
      mock_login_with(@user.email)
      page.should have_content(@user.email)
      visit show_member_path
      page.should have_content @user.email_name
    end

    context "as the admin of the organization" do
      before do
        @organization.membership(@user).update_attribute(:authority_type, 1)
        visit show_member_path
      end

      # 已激活用户能看到email_name
      it "should see activated colleagues email_name" do
        @organization.users.each do |user|
          page.should have_content user.email_name
        end
      end

      it "should see 邀请 button" do
        page.should have_button "邀请"
      end

      it "invite using invalid email address" do
        fill_in "user_email", :with => "test"
        click_button "邀请"
        page.should_not have_content "test@test.com"
        page.should have_content "邮件地址不合法"
      end

      # 邀请后，未激活用户仅能看到email地址，不另外测试
      it "invite an exist user, should see email_name" do
        fill_in "user_email", :with => @new_member.email
        click_button "邀请"
        page.should have_content @new_member.email_name
        User.find_by_email(@new_member.email).active_status.should eq(1)
      end

      it "invite a non-exist user, should see email_address" do
        fill_in "user_email", :with => "test@test.com"
        click_button "邀请"
        page.should have_content "test@test.com"
        User.find_by_email("test@test.com").active_status.should_not eq(1)
      end
    end

    context "non-admin user" do
      it "should see activated colleagues email_name & not see 邀请 button" do
        @organization.users.each do |user|
          page.should have_content user.email_name
        end
        page.should_not have_button "邀请"
      end
    end
  end

  describe "delete member", :js => true do
    before do
      @organization = create(:organization_with_multi_users)
      @user = @organization.users.first
      @new_member = create(:clean_user)
      mock_login_with(@user.email)
      page.should have_content(@user.email)
      visit show_member_path
      page.should have_content @user.email_name
    end

    context "as the admin of the organization" do
      before do
        @organization.membership(@user).update_attribute(:authority_type, 1)
        visit show_member_path
        @kicked_user = @organization.users.last
        page.should have_content @kicked_user.email_name
        all(:css, ".member-container a").last.click
      end

      it "should see 删除用户 button next to colleagues'name" do
        page.should have_content "删除该成员"
      end

      it "delete member action" do
        page.should_not have_content @kicked_user.email_name
        @organization.users.include?(@kicked_user).should eq(false)
      end

      it "create new topic should not see kicked_user in notifier list" do
        visit organization_topics_path(@organization)
        click_on "创建新话题"
        page.should_not have_content @kicked_user.email_name
      end
    end

    context "non-admin user" do
      it "should see activated colleagues email_name & not see 删除 button" do
        page.should have_content @organization.users.last.email_name
        page.should_not have_content "删除该成员"
      end
    end
  end

  describe "user without an organization", :js => true do
    before do
      @user = create(:clean_user)
      login_with(@user.email, @user.password)
      page.should have_content(@user.email)
      page.should have_content "请联系团队管理员，让您回到组织怀抱。"
    end

    it "visit topics path should redirect to no_organizations_path" do
      visit topics_path
      page.should have_content "请联系团队管理员，让您回到组织怀抱。"
    end

    it "visit organization topics path should redirect to no_organizations_path" do
      visit organization_topics_path(1)
      current_path.should == "/404.html"
    end
  end

  describe "user have other organizations" do
    before do
    user = create(:clean_user)
    @other_organization = create(:organization)
    @other_organization.users << user
    user.default_organization = @other_organization
    user.save
    login_with(user.email, user.password)
    end

    it "should directly redirect to other organization page" do
      visit root_path
      page.should have_content @other_organization.name
    end
  end
end
