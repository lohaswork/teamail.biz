# encoding: utf-8
class EmailReciversController < ApplicationController
  def email
    #should set the route for mailgun manully for development
    email = EmailEngine::EmailReciver::Email.new request.POST

    subject = email.subject
    sender = email.sender
    recipient = email.recipient
    body_plain = email.body_plain

    creator = User.find_by_email sender
    title = subject.blank? ? "此主题标题为空" : subject
    emails = creator.default_organization.users.map(&:email)
    Topic.create_topic(title, body_plain, emails, creator.default_organization, creator)
    # debugger
    render :nothing => true
  end
end
