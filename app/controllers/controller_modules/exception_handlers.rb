module ControllerModules::ExceptionHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, :with => :handle_unknown_error
  end

  protected
  def handle_unknown_error
  end

end
