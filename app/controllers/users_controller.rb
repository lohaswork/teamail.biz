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
    if user
      if user.active_status?
        flash[:notice] = "您的账户已经处于激活状态!"
        redirect_to root_path
      else
        user.update_attribute(:active_status, true)
      end
    else
      flash[:notice] = "激活失败，您的激活链接错误或不完整。"
      redirect_to root_path
    end
  end


  def do_forgot
    @email = params[:email]
    @user = User.find_by_email(@email)
    EmailEngine::ResetPasswordNotifier.new(@user).reset_password_notification if @user
  end

  def reset
    @reset_token = params[:reset_token]
    @user = @reset_token && User.find(@reset_token)
  end

  def do_reset
    User.reset_password(params[:reset_token], params[:password], params[:password_confirmation])
    render :json => {:status => "success", :redirect => login_path}
  end
end
