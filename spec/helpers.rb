# encoding: utf-8
#the helper method for test
module Helpers
  def sign_up_with(email, password, organization)
    visit signup_path
    fill_in 'user[email]', :with => email
    fill_in 'user[password]', :with => password
    fill_in 'organization_name', :with => organization
    click_button '注册'
  end

  def login_with(email, password)
    visit login_path
    fill_in 'email', :with => email
    fill_in 'password', :with => password
    click_button '登录'
  end
end
