# encoding: utf-8
class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.create_with_organization(params[:email], params[:password], params[:organization_name])
    send_signup_email(@user.email)
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
    if @user && @user.password = params[:password]
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

  protected

  def send_signup_email(to)
    RestClient.post "https://api:key-16qe6sz-8wtgabba2ei96pcb89823q65"\
    "@api.mailgun.net/v2/charleschu.mailgun.org/messages",
    :from => "LohasWork <notice@charleschu.mailgun.org>",
    :to => to,
    :subject => "注册成功",
    :text => "您已成功注册 LohasWork!"
  end
end
