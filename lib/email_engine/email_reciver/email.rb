  # encoding: utf-8
module EmailEngine
  module EmailReciver

    attr_reader :topic

    class Email
      def initialize(hash={}, gateway=EmailEngine::MailgunGateway.new)
        hash.each do |k, v|
          k = k.underscore
          self.define_singleton_method(k) do
            self.instance_variable_get("@#{k}")
          end
          self.define_singleton_method("#{k}=".to_sym) do |value|
            self.instance_variable_set("@#{k}", value)
          end
          self.send "#{k}=", v
        end

        @gateway = gateway
      end

      def resolve_email
        #resolve the email here
        @topic = nil #set it as nil for now
        @creator = User.find_by_email sender
        @creator = @creator.default_organization && @creator if @creator
        @organization = @creator.default_organization
        resolve_notifiers
      end

      def create_from_email
        resolve_email
        nvalid_creator_inotification && return if !@creator
        if @topic
          #create discussion here
        else
          title = subject.blank? ? "此主题标题为空" : subject
          @topic = Topic.create_topic(title, body_plain, @notifiers, @organization, @creator)
          EmailEngine::TopicNotifier.new(topic.id).create_topic_notification
        end
      end

      def invalid_creator_inotification_text
        @gateway.send_batch_message(
          to: sender,
          subject: "您的账户不合法",
          body: invalid_creator_inotification_text
        )
      end

      def set_notifiers
        email_regex = /\b[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\b/i
        @notifiers = []
        all_recipient_emails = to + "," + cc
        all_recipient_emails.split(',').each{ |address| @notifiers.concat( address.scan(email_regex) ) }
      end

      def resolve_notifiers
        set_notifiers
        @notifiers.each do |email|
          if !@organization.has_member?(email)
            organization.invite_user(email)
            EmailEngine::InvitationNotifier.new(email, @organization, @creator).invitation_notification
          end
        end
      end

      def invalid_creator_inotification_text
        <<-EMAIL
        <html><body>
        您尚未注册或尚不属于任何团队，请联系团队管理员邀请您加入或创建新团队。
        </body></html>
        EMAIL
      end

    end

  end
end
