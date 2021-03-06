# encoding: utf-8
class SessionsController < ApplicationController

  def new
    if is_logged_in?
      redirect_to login_user.default_organization.blank? ? no_organizations_path : personal_topics_inbox_path
    end
  end

  def create
    user = User.authentication(params[:email], params[:password])
    if params[:remember_me]
      cookies.permanent[:login_token] = user.remember_token
    else
      cookies[:login_token]= user.remember_token
    end
    update_current_organization(user.default_organization)
    if current_organization.blank?
      render :json => { :status => "success", :redirect => no_organizations_path }
    else
      render :json => { :status => "success", :redirect => personal_topics_inbox_path }
    end
  end

  def destroy
    cookies.delete(:login_token)
    session[:participators] = nil
    redirect_to login_path
  end
end
