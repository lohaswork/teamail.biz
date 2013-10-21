# encoding: utf-8
class SignupNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id, method_name, gateway = EmailEngine::MailgunGateway.new)
    EmailEngine::SignupNotifier.new(user_id).send(method_name)
  end
end
