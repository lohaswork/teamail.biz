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
      <html><body>
      你好：#{user.email}
      <p>您已成功注册 LohasWork!</p>
      <br/>
      请点击下面的链接激活您的账号
      <a href='http://#{@gateway.host_name}/active/#{user.active_code}'>
      http://#{@gateway.host_name}/active/#{user.active_code}</a>
      </body></html>
      EMAIL
    end
  end
end
