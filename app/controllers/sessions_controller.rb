# encoding: utf-8
class SessionsController < ApplicationController

  def new
    redirect_to topics_path if authenticated?
  end

  def create
    user = User.authentication(params[:email], params[:password])
    if params[:remember_me]
      cookies.permanent[:login_token] = user.remember_token
    else
      cookies[:login_token]= user.remember_token
    end
    update_current_organization(user.organization)
    render :json => {:status => "success", :redirect => topics_path}
  end

  def destroy
    cookies.delete(:login_token)
    redirect_to root_url, :notice => "登出！"
  end
end
