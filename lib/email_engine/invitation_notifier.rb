# encoding: utf-8
module EmailEngine
  class InvitationNotifier

    attr_reader :user, :gateway, :from, :organization_name

    def initialize(email, organization, invitation_from, is_registered_user, gateway=EmailEngine::MailgunGateway.new)
      @user = User.find_by_email email
      @organization_name = organization_name
      @from = User.find_by_email(invitation_from)
      @gateway = gateway
      @is_registered_user = is_registered_user
    end

    def invitation_notification
      notification_text = @is_registered_user ? on_board_text : invitation_notification_text
      gateway.send_batch_message(
        from: from.display_name + " " + from.email,
        to: user.email,
        subject: "一起来用 teamil.biz 进行项目管理",
        body: notification_text,
        message_id: invitation_message_id
      )
    end

    private

    def invitation_message_id
      "<#{@gateway.host_name(false)}/invitation/#{SecureRandom.urlsafe_base64}@mail.teamail.biz>"
    end

    def invitation_notification_text
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
                <table cellpadding="0" cellspacing="0" border="0" align="center">
                  <tr style="padding-top: 20px;">
                    <td width="600" valign="top" style="border-collapse: collapse; text-align: center;">
                      <p style="text-align: left;color: #666; padding-top: 20px;">
                        我正在使用 teamail.biz 进行项目管理, 希望你也能一起加入进来。
                      </p>
                      <p style="text-align: left;color: #666;">
                        请点击下面的链接马上加入。
                      </p>
                      <p style="text-align: left; padding-top: 10px; padding-bottom: 15px;">
                        <a style="color: #5BB65B;" href='#{@gateway.protocol}://#{@gateway.host_name}/reset/#{user.reset_token}'>
                          #{@gateway.protocol}://#{@gateway.host_name}/reset/#{user.reset_token}
                        </a>
                      </p>
                    </td>
                  <tr>
                </table>
              </td>
            </tr>
          </table>
        </body>
      </html>
      EMAIL
    end

    def on_board_text
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
                <table cellpadding="0" cellspacing="0" border="0" align="center">
                  <tr>
                    <td width="600" valign="top" style="border-collapse: collapse;"></td>
                      <p style="text-align: center;color: #666; padding-top: 20px;">
                        你已成功加入#{from.display_name}的组织
                      </p>
                    </td>
                  <tr>
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
