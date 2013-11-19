# encoding: utf-8
class EmailReceiversController < ApplicationController
  rescue_from Exceptions::PostEmailReceiveError, with: :render_406

  def email
    #should set the route for mailgun manully for development
    email = EmailEngine::EmailReceiver::Email.new request.POST
    #create the topic or discussion from email
    email.create_from_email
    render :nothing => true
  end

  private
  def render_406
    render :nothing => true, :status => 406
  end
end
