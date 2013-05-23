# encoding: utf-8
require 'spec_helper'

describe "SignUpPages" do
  before { visit '/' }

  describe "GET /" do
    it "See SignUp page" do
      page.should have_button('注册')
    end
  end

  describe "Do SignUp Success" do
    before do
      fill_in 'user[email]', :with => 'user@example.com'
      fill_in 'user[password]', :with => 'password'
      fill_in 'organization_name', :with => 'company'
    end

    it "should on the Success page" do
      click_button '注册'
      page.should have_content '您已成功注册并创建了您的公司或团体'
    end

    it "should Add one more user" do
      expect { click_button '注册' }.to change(User, :count).by(1)
    end
  end
end
