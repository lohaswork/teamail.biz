# encoding: utf-8
module EmailEngine
  class TopicNotifier

    attr_reader :gateway, :topic

    def initialize(topic_id, gateway=EmailEngine::MailgunGateway.new)
      @topic = Topic.find topic_id
      @gateway = gateway
    end


    def create_topic_notifaction(emails=deliver_emails)
      gateway.send_batch_message(
        to: emails,
        subject: topic.title,
        body: new_topic_notification_text
      )
    end


    private
    def deliver_emails
      topic.users.map(&:email)
    end

    def new_topic_notification_text
      <<-EMAIL
      <html><body>
      你好：#{topic.creator}创建了新话题：
      <p>#{topic.title}</p>
      <div>内容：</div>
      <div>topic.content<div>
      </body></html>
      EMAIL
    end
  end
end
