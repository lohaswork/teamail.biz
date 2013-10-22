# encoding: utf-8
class ResetPasswordNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    EmailEngine::ResetPasswordNotifier.new(user_id).reset_password_notification
  end
end
