# encoding: utf-8
require "active_record/validations.rb"
module ControllerModules::ExceptionHandlers
  extend ActiveSupport::Concern
  #TODO： error message mapping
  included do
    rescue_from ActiveRecord::RecordInvalid, ValidationError, :with => :handle_validation_error
    rescue_from ActiveRecord::RecordNotFound, :with => :handle_not_found_error
    rescue_from Exceptions::PostEmailReceiveError, :with => :render_406
  end

  protected
  def handle_validation_error(exception)
    log_the_error exception
    error_messages = []
    error_messages << exception.message
    error_messages.flatten!
    error_messages = ["信息有误"] if error_messages.blank?
    render :json => { :status => "error",
      :modal => {
        "message-dialog" => render_to_string(:partial => 'shared/error_and_notification',
                                             :locals => { error_messages: error_messages },
                                             :layout => false)
      }
    },
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

  def render_406(exception)
    log_the_error exception
    if Rails.env.production?
      Rails.logger.error exception.backtrace.join("\n")
      Rails.logger.error exception
    end
    render :nothing => true, :status => 406
  end

  def log_the_error(exception)
    if Rails.env.development? || Rails.env.test?
      Rails.logger.warn exception.backtrace.join("\n")
      Rails.logger.warn exception
    end
  end
end
