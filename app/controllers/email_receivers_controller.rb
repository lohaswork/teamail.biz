# encoding: utf-8
class EmailreceiversController < ApplicationController
  def email
    #should set the route for mailgun manully for development
    email = EmailEngine::Emailreceiver::Email.new request.POST
    #create the topic or discussion from email
    email.create_from_email
    render :nothing => true
  end
end
