# encoding: utf-8
class UsersController < ApplicationController
  def new
    redirect_to topics_path if authenticated?
  end

  def topics
    redirect_to(login_path) && return if !authenticated?
    @topics = current_user.topics
    @colleagues = get_colleagues
  end

  def create
    @user = User.create_with_organization(params[:user], params[:organization_name])
    EmailEngine::SignupNotifier.new(@user.id).sign_up_success_notification
    render :json => { :status => "success", :redirect => signup_success_path }
  end

  def active
    user = User.find_by_active_code(params[:active_code])
    # 激活失败的处理
    unless user && user.activate!
      flash[:notice] = user ? "您的账户已经处于激活状态!" : "激活失败，您的激活链接错误或不完整。"
      redirect_to login_path
    end
  end


  def do_forgot
    email = params[:email]
    user = User.forgot_password(email)
    render :json => { :status => "success", :redirect => forgot_success_path(user.remember_token) }
  end

  def reset
    @reset_token = params[:reset_token]
    @user = @reset_token && User.find_by_reset_token(@reset_token)
  end

  def do_reset
    User.reset_password(params[:reset_token], params[:password])
    render :json => { :status => "success", :redirect => reset_success_path }
  end

  def forgot_success
    @user = params[:token] && User.find_by_remember_token(params[:token])
    if !@user
      flash[:notice] = "链接有误"
      redirect_to forgot_path
    end
  end
end
