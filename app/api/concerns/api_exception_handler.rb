# Exception hanlders goes here
module ApiExceptionHandler
  extend ActiveSupport::Concern
  included do |base|
    handler_validation_error
  end

  module ClassMethods
    def handler_validation_error
      rescue_from Grape::Exceptions::ValidationErrors do |e|
        Rack::Response.new({
          errors: "Bad Request",
          error_description: e.message
        }.to_json, 400, { "Content-Type" => "application/json" })
      end
    end
  end
end
