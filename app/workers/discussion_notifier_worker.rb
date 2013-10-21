# encoding: utf-8
class DisscussionNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(discussion_id, selected_emails)
    EmailEngine::DiscussionNotifier.new(discussion_id, selected_emails).create_discussion_notification
  end
end
