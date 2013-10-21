# encoding: utf-8
class TopicNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(topic_id)
    EmailEngine::TopicNotifier.new(topic_id).create_topic_notification
  end
end
