# encoding: utf-8
class SessionsController < ApplicationController

  def new
    if authenticated?
      redirect_to current_user.default_organization.blank? ? no_organizations_path : topics_path
    end
  end

  def create
    user = User.authentication(params[:email], params[:password])
    if params[:remember_me]
      cookies.permanent[:login_token] = user.remember_token
    else
      cookies[:login_token]= user.remember_token
    end
    if user.default_organization.blank?
      render :json => { :status => "success", :redirect => no_organizations_path }
    else
      update_current_organization(user.default_organization)
      render :json => { :status => "success", :redirect => topics_path }
    end
  end

  def destroy
    cookies.delete(:login_token)
    redirect_to root_url, :notice => "登出！"
  end
end
