module ControllerModules::ExceptionHandlers
  extend ActiveSupport::Concern
  #TODO： error message mapping and logs

  included do
    rescue_from ActiveRecord::RecordInvalid, :with => :handle_validation_error
  end

  protected
  def handle_validation_error(exception)
    error_messages = exception.message
    error_messages = {:base => ["unexpected error"]} if error_messages.empty?
    render :json => {:status => "error", :message => "Validation failed", :code => 422, :errors => error_messages }, :status => 422
  end

end
