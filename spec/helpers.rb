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

  # Since bcrypt is a one-way hash function,
  # have to hardcode password in factory_girls mockup data.
  def mock_login_with(email)
    visit login_path
    fill_in 'email', :with => email
    fill_in 'password', :with => 'password'
    click_button '登录'
  end

  def login_with(email, password)
    visit login_path
    fill_in 'email', :with => email
    fill_in 'password', :with => password
    click_button '登录'
  end

  def wait_until
    require "timeout"
    Timeout.timeout(Capybara.default_wait_time) do
      sleep(0.1) until value = yield
      value
    end
  end

  def wait_for_ajax
    wait_until { page.evaluate_script("jQuery.active") == 0 }
  end
end
