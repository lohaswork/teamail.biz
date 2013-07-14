# encoding: utf-8
class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.create_with_organization(params[:user], params[:organization_name])
    EmailEngine::SignupNotifier.new(@user).sign_up_success_notification
    render :json => {:status => "success", :redirect => signup_success_path}
  end

  def signup_success

  end

  def active
    user = User.find_by_active_code(params[:active_code])
    if user
      if user.active_status?
        flash[:notice] = "您的账户已经处于激活状态，请勿重复激活!"
        redirect_to root_path
      else
        user.update_attribute(:active_status, true)
      end
    else
      flash[:notice] = "激活失败，您的激活链接错误或不完整。"
      redirect_to root_path
    end
  end

  def login

  end

  def do_login
    @email = params[:email]
    @user = User.find_by_email(@email)
    if @user && @user.password == params[:password]
      render :nothing => true
    else
      render :nothing => true
    end
  end

  def forgot

  end

  def do_forgot
    @email = params[:email]
    @user = User.find_by_email(@email)
  end
end
