# encoding: utf-8
module EmailEngine
  class SignupNotifier

    attr_reader :user, :gateway

    def initialize(user, gateway=EmailEngine::MailgunGateway.new)
      @user = user
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
      <HTML><body>
      你好：#{user.email} 
      <p>您已成功注册 LohasWork!</p>
      <br/>
      请点击下面的链接激活您的账号
      <a href='http://0.0.0.0:3000/active?email=#{user.email}&active_code=#{user.active_code.code}'>
      http://0.0.0.0:3000/active?email=#{user.email}&active_code=#{user.active_code.code}</a>
      </body></html>
      EMAIL
    end
  end
end
