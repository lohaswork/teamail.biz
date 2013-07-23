# encoding: utf-8
class UsersController < ApplicationController
  def new
    redirect_to welcome_path if current_user
  end

  def create
    @user = User.create_with_organization(params[:user], params[:organization_name])
    EmailEngine::SignupNotifier.new(@user).sign_up_success_notification
    render :json => {:status => "success", :redirect => signup_success_path}
  end

  def active
    user = User.find_by_active_code(params[:active_code])
    # 激活失败的处理
    unless user && user.activate!
      flash[:notice] = user ? "您的账户已经处于激活状态!" : "激活失败，您的激活链接错误或不完整。"
      redirect_to root_path
    end
  end


  def do_forgot
    @email = params[:email]
    User.forgot_password(@email)
    render :json => {:status => "success", :redirect => forgot_success_path}
  end

  def reset
    @reset_token = params[:reset_token]
    @user = @reset_token && User.find_by_reset_token(@reset_token)
  end

  def do_reset
    User.reset_password(params[:reset_token], params[:password])
    render :json => {:status => "success", :redirect => reset_success_path}
  end
end
