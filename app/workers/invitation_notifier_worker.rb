# encoding: utf-8
class InvitationNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(email, organization, invitation_from, email_status)
    EmailEngine::InvitationNotifier.new(email, organization, invitation_from)
      .invitation_notification(email_status)
  end
end
