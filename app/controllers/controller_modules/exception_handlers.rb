# encoding: utf-8
require "active_record/validations.rb"
module ControllerModules::ExceptionHandlers
  extend ActiveSupport::Concern
  #TODO： error message mapping
  included do
    rescue_from ActiveRecord::RecordInvalid, ValidationError, :with => :handle_validation_error
    rescue_from ActiveRecord::RecordNotFound, :with => :handle_not_found_error
  end

  protected
  def handle_validation_error(exception)
    log_the_error exception
    error_messages = exception.message
    error_messages = ["信息有误"] if error_messages.blank?
    render :json => { :status => "error",
                      :message => (render_to_string 'shared/_error_messages',
                                                    locals: { error_messages: error_messages },
                                                    :layout => false) },
                    :status => 422
  end

  def handle_not_found_error(exception)
    log_the_error exception
    if request.xhr?
      render :json => { :redirect_to => '/404.html' },
                      :status => 404
    else
      redirect_to '/404.html'
    end
  end

  def log_the_error(exception)
    if Rails.env.development? || Rails.env.test?
      Rails.logger.warn exception.backtrace.join("\n")
      Rails.logger.warn exception
    end
  end
end
