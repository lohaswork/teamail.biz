# encoding: utf-8
module EmailEngine
  class TopicNotifier

    attr_reader :gateway, :topic

    def initialize(topic_id, selected_emails,gateway=EmailEngine::MailgunGateway.new)
      @emails = selected_emails
      @topic = Topic.find topic_id
      @gateway = gateway
    end


    def create_topic_notification(emails=@emails)
      gateway.send_batch_message(
        from: topic.creator.email_name,
        to: emails,
        subject: topic.email_title || topic.title,
        body: new_topic_notification_text
      )
    end


    private
    def new_topic_notification_text
      <<-EMAIL
      <html><body>
      你好：#{topic.creator.email}创建了新话题：
      <p>#{topic.title}</p>
      <div>内容：</div>
      <div>#{topic.content}<div>
      <br/>
      点击查看：
      <a href='http://#{@gateway.host_name}/topics/#{topic.id}'>
      http://#{@gateway.host_name}/topics/#{topic.id}</a>
      </body></html>
      EMAIL
    end
  end
end
