# encoding: utf-8
class InvitationNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(email, organization, invitation_from, is_registered_user)
    EmailEngine::InvitationNotifier.new(email, organization, invitation_from, is_registered_user)
      .invitation_notification
  end
end
