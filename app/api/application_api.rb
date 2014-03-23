class ApplicationApi < Grape::API

  include APIGuard
  include Grape::Kaminari
  include ApiExceptionHandler
  include ApiHelper

  version "#{$config.api_version}", using: :path
  format :json
  formatter :json, Grape::Formatter::Jbuilder

  #Mount the api class here
  mount TopicApi

  #Handle 404 error in scope /api/v1
  route :any, '*path' do
    error!("No such route", 404)
  end

end
