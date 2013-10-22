# encoding: utf-8
class SignupNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    EmailEngine::SignupNotifier.new(user_id).sign_up_success_notification
  end
end
