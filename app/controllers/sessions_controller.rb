# encoding: utf-8
class SessionsController < ApplicationController

  def new
    redirect_to welcome_path if authenticated?
  end

  def create
    user = User.authentication(params[:email], params[:password])
    if params[:remember_me]
      cookies.permanent[:login_token] = user.remember_token
    else
      cookies[:login_token]= user.remember_token
    end
    render :json => {:status => "success", :redirect => welcome_path}
  end

  def destroy
    cookies.delete(:login_token)
    redirect_to root_url, :notice => "登出！"
  end
end
