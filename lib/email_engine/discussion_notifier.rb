# encoding: utf-8
module EmailEngine
  class DiscussionNotifier

    attr_reader :gateway, :discussion

    def initialize(discussion_id, selected_emails, gateway=EmailEngine::MailgunGateway.new)
      @emails = selected_emails
      @discussion = Discussion.find discussion_id
      @gateway = gateway
    end


    def create_discussion_notification(emails=@emails)
      gateway.send_batch_message(
        from: discussion.creator.email_name,
        to: emails,
        subject: topic.title,
        body: new_discussion_notification_text
      )
    end


    private
    def topic
      discussion.discussable_type == "Topic" && discussion.discussable
    end

    def new_discussion_notification_text
      <<-EMAIL
      <html><body>
      你好：#{discussion.creator.email}回复话题#{topic.title}：
      <br/>
      <div>内容：</div>
      <div>#{discussion.content}<div>
      <br/>
      点击查看：
      <a href='http://#{@gateway.host_name}/topics/#{topic.id}'>
      http://#{@gateway.host_name}/topics/#{topic.id}</a>
      </body></html>
      EMAIL
    end
  end
end
