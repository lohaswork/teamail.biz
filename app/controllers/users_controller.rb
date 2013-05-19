# encoding: utf-8
class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.create_with_organization(params[:user], params[:organization_name])
    EmailEngine::SignupNotifier.new(@user).sign_up_success_notification
    redirect_to signup_success_path
  end

  def signup_success

  end

  def confirm

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
