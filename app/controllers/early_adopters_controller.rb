# encoding: utf-8
class EarlyAdoptersController < ApplicationController
  def index
    if authenticated?
      redirect_to welcome_path
    else
      render :layout => false
    end
  end

  def create
    email = params[:email]
    begin
      EarlyAdopter.create!(:email => email)
      render :partial => 'create_success'
    rescue Exception => e
      render :json => {:status => "error", :message => "Validation failed", :code => 422, :errors => e.message }, :status => 422
    end
  end
end
