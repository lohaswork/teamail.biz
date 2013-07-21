# encoding: utf-8
require 'spec_helper'

describe "user authentaction action" do
  #the helper method for test
  def sign_up_with(email, password, organization)
    visit root_path
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

  describe "user signup" do
    describe "user visit signup page" do
      it "see signup page" do
        visit root_path
        page.should have_button('注册')
      end
    end

    describe "user signup success" do
      it "should add one more user", :js => true do
        sign_up_with('user@example.com', 'password', 'company')
        expect {
          page.should have_content '您已成功注册并创建了您的公司或团体'
        }.to change(User, :count).by(1)
      end
    end

    describe "user signup fail" do
      context "uer fill in email not correct" do
        it "should ask for email address when not fill in", :js => true do
          sign_up_with(nil, 'password', 'company')
          page.should have_content '请输入邮件地址'
        end

        it "should say not valid when email address invalid", :js => true do
          sign_up_with('not@correct', 'password', 'company')
          page.should have_content '邮件地址不合法'
        end
      end

      describe "fill in already used info" do
        before do
          sign_up_with('user@example.com', 'password', 'company')
        end

        context "user fill in used email, not casesensitve", :js => true do
          it "should say email already used" do
            sign_up_with('USER@example.com', 'password', 'company-test')
            page.should have_content '邮件地址已使用'
          end
        end

        context "user fill in used campany name, not casesensitve", :js => true do
          it "should say organization name already used" do
            sign_up_with('user-test@example.com', 'password', 'COMPANY')
            page.should have_content '组织名已使用'
          end
        end
      end
    end
  end

  describe "user active" do

    context "with valid active link and never activate before" do

      it "should see active succsess info" do
        user = create(:non_activate_user)
        visit "/active?active_code=#{user.active_code}"
        page.should have_content '您的电子邮箱已通过验证。'
      end
    end

    context "with valid active link yet activated before" do

      it "should see active failure info" do
        user = create(:already_activate_user)
        visit "/active?active_code=#{user.active_code}"
        page.should have_content '您的账户已经处于激活状态!'
      end
    end

    context "with invalid active link" do

      it "should not see active failure info" do
        visit "/active?active_code=invalidinfo"
        page.should have_content '激活失败，您的激活链接错误或不完整。'
      end
    end
  end

  describe "user login" do

    context "user click the login link" do
      it "should on the login page" do
        visit root_path
        click_on "登录"
        current_path.should == '/login'
      end
    end

    context "user visit login page" do
      it "should see login page" do
        visit login_path
        page.should have_button('登录')
      end
    end

    context "user login succsess", :js => true do
      before {sign_up_with('user@example.com', 'password', 'company')}
      it "should see user message" do
        login_with("user@example.com", "password")
        page.should have_content '欢迎您：user@example.com'
      end
    end

    context "user visit pages after login succsess" do
      before do
        sign_up_with('user@example.com', 'password', 'company')
        login_with("user@example.com", "password")
      end
      it "should redirect to welcome page visit root path" do
        visit root_path
        current_path.should == '/welcome'
        page.should have_content('user@example.com')
      end

      it "should redirect to welcome page visit login path" do
        visit login_path
        current_path.should == '/welcome'
        page.should have_content('user@example.com')
      end

      it "should go to root path after logout" do
        visit root_path
        click_on("登出")
        current_path.should == "/"
        page.should_not have_content('user@example.com')
      end
    end

    describe "user login failed" do
      before {sign_up_with('user@example.com', 'password', 'company')}

      context "user miss email or password", :js => true do
        it "should see error message" do
          login_with(nil, "password")
          page.should have_content '信息不正确'
        end

        it "should see error message" do
          login_with(nil, nil)
          page.should have_content '信息不正确'
        end
      end
      context "user enter error message", :js => true do
        it "should see error message" do
          login_with("error@email.com", "password")
          page.should have_content '信息不正确'
        end

        it "should see error message" do
          login_with("error@email.com", "wrongpassword")
          page.should have_content '信息不正确'
        end
      end
    end


    context "user click the forgot password" do
      it "should go to forget password page" do
        visit login_path
        click_on "忘记密码"
        current_path.should == "/forgot"
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
