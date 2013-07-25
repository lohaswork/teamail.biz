# encoding: utf-8
class SessionsController < ApplicationController

  def new
    redirect_to welcome_path if authenticated?
  end

  def create
    user = User.authentication(params[:email], params[:password])
    if params[:remember_me]
      cookies.permanent[:remember_me] = user.remember_token
    else
      cookies[:remember_me]= user.remember_token
    end
    render :json => {:status => "success", :redirect => root_path}
  end

  def destroy
    cookies.delete(:remember_me)
    redirect_to root_url, :notice => "登出！"
  end
end
