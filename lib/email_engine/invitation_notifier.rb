# encoding: utf-8
module EmailEngine
  class InvitationNotifier

    attr_reader :user, :gateway, :from, :organization_name

    def initialize(email, organization, invitation_from, is_registered_user, gateway=EmailEngine::MailgunGateway.new)
      @user = User.find_by_email email
      @organization_name = organization_name
      @from = User.find_by_email invitation_from
      @gateway = gateway
      @is_registered_user = is_registered_user
    end

    def invitation_notification
      notification_text = @is_registered_user ? on_board_text : invitation_notification_text
      gateway.send_batch_message(
        from: from.email_name,
        to: user.email,
        subject: "[TeaMail]邀请加入#{organization_name}",
        body: notification_text
      )
    end

    private

    def invitation_notification_text
      <<-EMAIL
      <html><body>
      你好：#{user.email}
      <p>#{from}邀请您加入他/她的组织</p>
      <p>点击下方链接即刻加入！</p>
      <br/>
      <a href='http://#{@gateway.host_name}/reset/#{user.reset_token}'>
      http://#{@gateway.host_name}/reset/#{user.reset_token}</a>
      </body></html>
      EMAIL
    end

    def on_board_text
      <<-EMAIL
      <html><body>
      你好：#{user.email}
      <p>您已成功加入#{from}的组织</p>
      </body></html>
      EMAIL
    end
  end
end
