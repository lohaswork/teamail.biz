# encoding: utf-8
module EmailEngine
  class ResetPasswordNotifier

    attr_reader :user, :gateway

    def initialize(user, gateway=EmailEngine::MailgunGateway.new)
      @user = user
      @gateway = gateway
    end

    def reset_password_notification
      gateway.send_batch_message(
        to: user.email,
        subject: "重置密码",
        body: reset_password_notification_text
      )
    end

    private

    def reset_password_notification_text
      <<-EMAIL
      <html><body>
      你好：#{user.email}
      <p>您已申请重置 [ 乐活工场 ] 的登录密码。</p>
      <p>请点击下面的链接完成操作。</p>
      <br/>
      请点击下面的链接重置您的密码
      <a href='http://#{@gateway.host_name}/reset/#{user.reset_token}'>
      http://#{@gateway.host_name}/reset/#{user.reset_token}</a>
      </body></html>
      EMAIL
    end
  end
end
