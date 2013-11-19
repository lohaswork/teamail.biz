  # encoding: utf-8
module EmailEngine
  module EmailReceiver

    module Notifier
      extend ActiveSupport::Concern

      def invalid_creator_notification
        @gateway.send_batch_message(
          to: sender,
          subject: "您的账户不合法",
          body: invalid_creator_notification_text,
          message_id: invalid_message_id
        )
      end

      def invalid_message_id
        "<#{@gateway.host_name(false)}/invalid/#{SecureRandom.urlsafe_base64}@mail.teamail.biz>"
      end

      def invalid_creator_notification_text
        <<-EMAIL
        <html><body>
        您尚未注册或尚不属于任何团队，请联系团队管理员邀请您加入或创建新团队。
        </body></html>
        EMAIL
      end
    end
  end
end
