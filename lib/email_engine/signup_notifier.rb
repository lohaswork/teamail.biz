# encoding: utf-8
module EmailEngine
  class SignupNotifier

    attr_reader :user, :gateway

    def initialize(user_id, gateway=EmailEngine::MailgunGateway.new)
      @user = User.find user_id
      @gateway = gateway
    end

    def sign_up_success_notification
      gateway.send_batch_message(
        to: user.email,
        subject: "注册成功",
        body: signup_notification_text
      )
    end

    private

    def signup_notification_text
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
                    <td width="600" valign="top" style="border-collapse: collapse;">
                      <p style="text-align: center;color: #666;">
                        您已成功注册 [ teamail.biz ] 并创建了您的公司或团体。
                      </p>
                      <p style="text-align: center;color: #666;">
                        为了确保您的账户安全,请点击下面的链接验证您的邮箱地址。
                      </p>
                      <br>
                      <p style="text-align: center;">
                        <a style="color: #5BB65B;" href='http://#{@gateway.host_name}/active/#{user.active_code}'>
                          http://#{@gateway.host_name}/active/#{user.active_code}
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
  end
end
