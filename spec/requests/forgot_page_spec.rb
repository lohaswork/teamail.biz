# encoding: utf-8
require 'spec_helper'

describe "ForgetPasswordPage" do
  before { visit '/forgot' }

  describe "GET /forgot" do
    it "See forgot page" do
      page.should have_button('发送邮件重置密码')
    end
  end

  describe "no such user" do
    it "Have not fill in user email" do
      click_button '发送邮件重置密码'
      page.should have_content '没有这个用户'
    end
  end
end
