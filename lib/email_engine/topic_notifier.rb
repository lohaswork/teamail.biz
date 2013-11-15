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

    def topic_notify_party_with_format
      notify_emails = topic.discussions.first.notify_party.map { |user| user.email }
      notify_emails.join ", "
    end

    def new_topic_notification_text
      <<-EMAIL
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//CN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
      <html>
        <head>
          <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        </head>
        <body style="width:100% !important; -webkit-text-size-adjust:100%; -ms-text-size-adjust:100%; margin:0; padding:0;">
          <table cellpadding="0" cellspacing="0" border="0" id="backgroundTable">
            <tr>
              <td style="border-collapse: collapse;">
                <table cellpadding="0" cellspacing="0" border="0" align="left">
                  <tr style="padding-top: 20px;">
                    <td width="600" valign="top" style="border-collapse: collapse; background-color: #F4FAF2; line-height: 35px; height: 35px; color: #999;">
                      <span style="margin-right: 20px; color: #588CC7; margin-left:15px;">#{topic.creator.email}</span>
                      #{topic.created_at.strftime("%Y年%m月%d日 %H:%M")}
                      <span style="margin-left: 60px;">teamail.biz 邮件</span>
                    </td>
                  <tr>
                  <tr>
                    <td width="600" valign="top" style="border-collapse: collapse; color: #777; padding-top: 8px;">
                      <span style="margin-right: 20px;">发送至:</span>
                        #{topic_notify_party_with_format}
                    </td>
                  </tr>
                  <tr>
                    <td width="600" valign="top" style="border-collapse: collapse; padding-top: 15px;">
                      #{topic.content}
                    </td>
                  </tr>
                  <tr>
                    <td width="600" valign="top" style="border-collapse: collapse; padding-top: 10px; color: #777;">
                      点击链接进入teamail.biz查看：<a href='http://#{@gateway.host_name}/topics/#{topic.id}'>http://#{@gateway.host_name}/topics/#{topic.id}</a>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </body>
      </html>
      EMAIL
    end
  end
end
