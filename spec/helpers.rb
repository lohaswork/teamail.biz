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

  def editor_fill_in(options)
    if options[:in]
      parent = "('#{options[:in]}').find"
    else
      parent = ""
    end
    page.execute_script( "$#{parent}('textarea.qeditor').css('display','block');" )
    page.execute_script( "$#{parent}('textarea.qeditor').val('#{options[:with]}');" )
  end

  def wait_for_ajax
    counter = 0
    while page.evaluate_script("$.active").to_i > 0
      counter += 1
      sleep(0.1)
      raise "AJAX request took longer than 5 seconds." if counter >= 50
    end
  end
end
