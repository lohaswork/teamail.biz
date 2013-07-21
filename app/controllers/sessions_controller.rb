# encoding: utf-8
class SessionsController < ApplicationController

  def new
    redirect_to welcome_path if current_user
  end

  def create
    user = User.authentication(params[:email], params[:password])
    if params[:remember_me]
      cookies.permanent.signed[:remember_me] = user.id
    else
      cookies.signed[:remember_me] = user.id
    end
    render :json => {:status => "success", :redirect => root_path}
  end

  def destroy
    cookies.delete(:remember_me)
    redirect_to root_url, :notice => "登出！"
  end
end
