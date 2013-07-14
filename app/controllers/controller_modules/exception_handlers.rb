# encoding: utf-8
require "active_record/validations.rb"
module ControllerModules::ExceptionHandlers
  extend ActiveSupport::Concern
  #TODO： error message mapping
  included do
    rescue_from ActiveRecord::RecordInvalid, :with => :handle_validation_error
  end

  protected
  def handle_validation_error(exception)
    if Rails.env.development? || Rails.env.test?
      Rails.logger.warn exception.backtrace.join("\n")
      Rails.logger.warn exception
    end
    error_messages = exception.message
    error_messages = "unexpected error" if error_messages.blank?
    render :json => {:status => "error", :message => "Validation failed", :code => 422, :errors => error_messages }, :status => 422
  end

end
