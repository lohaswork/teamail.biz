# encoding: utf-8
require 'spec_helper'

describe "user authentaction action" do
  describe "user signup" do
    before { visit '/' }

    describe "user visit signup page" do
      it "see signup page" do
        page.should have_button('注册')
      end
    end

    describe "user signup success" do
      before do
        fill_in 'user[email]', :with => 'user@example.com'
        fill_in 'user[password]', :with => 'password'
        fill_in 'organization_name', :with => 'company'
      end

      it "should add one more user", :js => true do
        expect {
          click_button '注册'
          page.should have_content '您已成功注册并创建了您的公司或团体'
        }.to change(User, :count).by(1)
      end
    end

    describe "user signup fail" do
      describe "uer fill in email not correct" do
        it "should ask for email address when not fill in", :js => true do
          fill_in 'user[password]', :with => 'password'
          fill_in 'organization_name', :with => 'company'
          click_button '注册'
          page.should have_content '请输入邮件地址'
        end

        it "should say not valid when email address invalid", :js => true do
          fill_in 'user[email]', :with => 'not@correct'
          fill_in 'user[password]', :with => 'password'
          fill_in 'organization_name', :with => 'company'
          click_button '注册'
          page.should have_content '邮件地址不合法'
        end
      end
    end
  end

  describe "user login" do
    before { visit '/login' }

    describe "user visit login page" do
      it "should see login page" do
        page.should have_button('登录')
      end
    end
  end

  describe "user forgot password" do
    before { visit '/forgot' }

    describe "user visit forgot password page" do
      it "should see forgot page" do
        page.should have_button('发送邮件重置密码')
      end
    end

    describe "forgot password when no such user" do
      it "have not fill in user email" do
        click_button '发送邮件重置密码'
        page.should have_content '没有这个用户'
      end
    end
  end
end
