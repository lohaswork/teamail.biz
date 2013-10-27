  # encoding: utf-8
module EmailEngine
  module EmailReceiver

    module Notifier
      extend ActiveSupport::Concern

      def invalid_creator_notification
        @gateway.send_batch_message(
          to: sender,
          subject: "您的账户不合法",
          body: invalid_creator_notification_text
        )
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
