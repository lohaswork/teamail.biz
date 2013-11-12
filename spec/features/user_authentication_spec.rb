# encoding: utf-8
require 'spec_helper'
require 'helpers'

describe "user authentaction action" do
  include Helpers

  describe "user signup" do
    describe "user visit signup page" do
      it "see signup page" do
        visit signup_path
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

      describe "user active" do

        context "with valid active link and never activate before" do

          it "should see active succsess info" do
            user = create(:non_activate_user)
            visit "/active/#{user.active_code}"
            page.should have_content '您的电子邮箱已通过验证。'
          end
        end

        context "with valid active link yet activated before" do

          it "should see active failure info" do
            user = create(:normal_user)
            visit "/active/#{user.active_code}"
            page.should have_content '您的账户已经处于激活状态!'
          end
        end

        context "with invalid active link" do

          it "should not see active failure info" do
            visit "/active/invalidinfo"
            page.should have_content '激活失败，您的激活链接错误或不完整。'
          end
        end
      end
    end

    describe "user signup fail" do
      context "uer fill in email not correct" do
        it "should ask for email address when not fill in" do
          sign_up_with(nil, 'password', 'company')
          page.should have_content '请输入邮件地址'
        end

        it "should say not valid when email address invalid" do
          sign_up_with('not@correct', 'password', 'company')
          page.should have_content '邮件地址不合法'
        end
      end

      describe "fill in already used info" do
        before do
          sign_up_with('user@example.com', 'password', 'company')
        end

        context "user fill in used email, not casesensitve" do
          it "should say email already used" do
            sign_up_with('USER@example.com', 'password', 'company-test')
            page.should have_content '邮件地址已使用'
          end
        end
      end
    end
  end

  describe "user login" do

    context "user click the login link" do
      it "should on the login page" do
        visit signup_path
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

    context "user login succsess" do
      let(:user) { create(:normal_user) }
      it "should go to the personal sapce page", :js => true do
        login_with(user.email, user.password)
        page.should have_content user.topics.first.title
        current_path.should == '/personal_topics_inbox'
      end
    end

    context "user visit pages after login succsess", :js => true do
      let(:user) { create(:normal_user) }
      before do
        login_with(user.email, user.password)
        page.should have_content("登出")
      end

      it "should redirect to topics page visit login path" do
        visit login_path
        current_path.should == '/personal_topics_inbox'
      end

      it "should redirect to topics page visit signup_path" do
        visit signup_path
        current_path.should == '/personal_topics_inbox'
      end

      it "should go to root path after logout" do
        visit organization_topics_path
        click_on("登出")
        current_path.should == "/login"
        page.should_not have_content '登出'
      end
    end

    describe "user login failed" do
      before {@user = create(:normal_user)}

      context "user miss email or password", :js => true do
        it "should see error message" do
          login_with(nil, "password")
          page.should have_content '没有这个用户'
        end

        it "should see error message" do
          login_with(nil, nil)
          page.should have_content '没有这个用户'
        end
      end
      context "user enter error message", :js => true do
        it "should see error message" do
          login_with("error@email.com", "password")
          page.should have_content '没有这个用户'
        end

        it "should see error message" do
          login_with(@user.email, "wrongpassword")
          page.should have_content '密码或邮件地址不正确'
        end
      end

      context "an not active user login", :js => true do
        it "should see error message" do
          user = create(:non_activate_user)
          login_with(user.email, user.password)
          page.should have_content '您的账户尚未激活'
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
    before { visit forgot_path }

    context "user visit forgot password page" do
      it "should see forgot page" do
        page.should have_button('发送邮件重置密码')
      end
    end

    context "forgot password when no such user" do
      it "should say your email is incorrect" do
        click_button '发送邮件重置密码'
        page.should have_content '您的邮件地址不正确'
      end
    end

    context "fill in a correct email", :js => true do
      let(:user) { create(:non_activate_user) }
      it "should go to the forgot succsess page" do
        fill_in "email", :with => user.email
        click_button '发送邮件重置密码'
        page.should have_content '重置密码的邮件已发送至您的邮箱。'
        page.should have_content user.email
      end
    end
  end

  describe "user reset password" do
    let(:user) { create(:should_reset_user) }

    describe "user reset succsess" do
      context "user click reset password link" do
        it "should on the reset password page if link is right" do
          visit "/reset/#{user.reset_token}"
          page.should have_button "重置密码"
        end
      end
      context "user reset succsess", :js => true do
        it "should on the succsess page" do
          visit "/reset/#{user.reset_token}"
          fill_in 'password', :with => "new-password"
          click_button "重置密码"
          page.should have_content "您已重新设置了密码。"
        end
      end
    end

    describe "user reset failed" do
      context "link is not correct" do
        it "should saw error message if link is incorrect" do
          visit "/reset/incorrect-link"
          page.should have_content "您的链接已失效"
        end
      end

      context "user enter an incorrect password"do
        it "should saw error message" do
          visit "/reset/#{user.reset_token}"
          fill_in 'password', :with => "wrong"
          click_button "重置密码"
          page.should have_content "密码至少需要六位"
        end
      end

      context "user click an used link", :js => true do
        before do
          visit "/reset/#{user.reset_token}"
          fill_in 'password', :with => "new-password"
          click_button "重置密码"
          page.should have_content "您已重新设置了密码。"
        end

        it "should saw error message" do
          visit "/reset/#{user.reset_token}"
          page.should have_content "您的链接已失效"
        end
      end
    end
  end
end
