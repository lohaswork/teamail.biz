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
        to: emails,
        subject: topic.email_title || topic.title,
        body: new_discussion_notification_text,
        message_id: discussion_message_id,
        in_reply_to: reply_header
      )
    end


    private

    def topic
      discussion.discussable_type == "Topic" && discussion.discussable
    end

    def discussion_message_id
      "<#{@gateway.host_name(false)}/topics/#{topic.id}/discussion/#{discussion.id}@mail.teamail.biz>"
    end

    def reply_header
      "<#{@gateway.host_name(false)}/topics/#{topic.id}@mail.teamail.biz>"
    end

    def new_discussion_notification_text
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
                    <td width="600" valign="top" style="border-collapse: collapse; color: #777; padding-top: 10px;">
                      #{discussion.creator.email_name} 写道:
                    </td>
                  </tr>
                  <tr>
                    <td width="600" valign="top" style="border-collapse: collapse; padding-top: 15px;">
                      #{discussion.content}
                    </td>
                  </tr>
                  <tr>
                    <td width="600" valign="top" style="border-collapse: collapse; padding-top: 15px; color: #777;">
                      点击链接进入teamail查看：<a href='#{@gateway.protocol}://#{@gateway.host_name}/topics/#{topic.id}'>#{@gateway.protocol}://#{@gateway.host_name}/topics/#{topic.id}</a>
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
