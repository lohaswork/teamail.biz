# encoding: utf-8
require 'spec_helper'

describe "SignUpPages" do
  describe "GET /" do
    it "See root page" do
      visit '/'
      page.should have_content('Home')
    end
  end

  it "signs me in" do
    visit '/'
    fill_in 'user[email]', :with => 'user@example.com'
    fill_in 'user[password]', :with => 'password'
    fill_in 'organization_name', :with => 'company'
    click_button '注册'
    page.should have_content '您已成功注册并创建了您的公司或团体'
  end
end
