# encoding: utf-8
class TopicNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(topic_id, selected_emails)
    EmailEngine::TopicNotifier.new(topic_id, selected_emails).create_topic_notification
  end
end
