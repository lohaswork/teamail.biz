# encoding: utf-8
module EmailEngine
  class DiscussionNotifier

    attr_reader :gateway, :discussion

    def initialize(discussion_id, gateway=EmailEngine::MailgunGateway.new)
      @discussion = Discussion.find discussion_id
      @gateway = gateway
    end


    def create_discussion_notification(emails=deliver_emails)
      gateway.send_batch_message(
        to: emails,
        subject: topic.title,
        body: new_discussion_notification_text
      )
    end


    private
    def topic
      discussion.topic
    end

    def deliver_emails
      topic.users.map(&:email)
    end

    def new_discussion_notification_text
      <<-EMAIL
      <html><body>
      你好：#{discussion.creator.email}回复话题#{topic.title}：
      <br/>
      <div>内容：</div>
      <div>#{discussion.content}<div>
      </body></html>
      EMAIL
    end
  end
end
