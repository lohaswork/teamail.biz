# encoding: utf-8
require "active_record/validations.rb"
module ControllerModules::ExceptionHandlers
  extend ActiveSupport::Concern
  #TODO： error message mapping and logs

  included do
    rescue_from ActiveRecord::RecordInvalid, :with => :handle_validation_error
  end

  protected
  def handle_validation_error(exception)
    error_messages = error_mapping(exception.message)
    error_messages = "unexpected error" if error_messages.blank?
    render :json => {:status => "error", :message => "Validation failed", :code => 422, :errors => error_messages }, :status => 422
  end

  def error_mapping(message)
    #This is hard code for test
    return '请输入邮件地址' if message =~ /Email can't be blank/
    return '邮件地址不合法' if message =~ /Email is invalid/
    message
  end

end
