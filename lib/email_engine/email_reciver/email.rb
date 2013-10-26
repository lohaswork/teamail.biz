  # encoding: utf-8
module EmailEngine
  module EmailReciver

    class Email
      include EmailEngine::EmailReciver::EmailContentResolution
      include EmailEngine::EmailReciver::AttachmentHandler

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
        @topic = resolve_topic_of_email
        @creator = User.find_by_email sender
        if is_creator_discussion?
          @organization = @topic.organization
          #set the creator to nil as invalid if the organization has not the creator
          @creator = nil if !@organization.has_member?(sender)
        else
          @organization = @creator && @creator.default_organization
          #set the creator to nil as invalid if the creator has no organization
          @creator = nil if !@organization
        end
        resolve_notifiers
      end

      def is_creator_discussion?
        !!@topic
      end

      def resolve_topic_of_email
        topic_id = body_html[/#{Regexp.escape(@gateway.host_name)}\/topics\/(.*?)\"/m, 1]
        topic_id = topic_id.blank? ? nil : topic_id.to_i
        topic_id && Topic.find(topic_id)
      end

      def create_from_email
        resolve_email
        invalid_creator_inotification && return if !@creator
        if is_creator_discussion?
          content = stripped_text.blank? ? "此封内容为空" : stripped_text
          discussion = Discussion.create_discussion(@creator, @topic, @notifiers, content)
          post_attachments_to_oss(discussion) if self.has_attachments?
          EmailEngine::DiscussionNotifier.new(discussion.id, @notifiers).create_discussion_notification
        else
          title = subject.blank? ? "此主题标题为空" : analyzed_title
          @topic = Topic.create_topic(title, stripped_text, @notifiers, @organization, @creator)
          add_tags_to(@topic)
          post_attachments_to_oss(@topic.discussions.first) if self.has_attachments?
          EmailEngine::TopicNotifier.new(@topic.id).create_topic_notification
        end
      end

      def invalid_creator_inotification
        @gateway.send_batch_message(
          to: sender,
          subject: "您的账户不合法",
          body: invalid_creator_inotification_text
        )
      end

      def set_notifiers
        email_regex = /\b[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\b/i
        @notifiers = []
        all_recipient_emails = to + "," + (self.methods.include?(:cc) ? self.cc : '')
        all_recipient_emails.split(',').map{ |address| @notifiers.concat( address.scan(email_regex) ) }
        @notifiers = (@topic.users.map(&:email) + @notifiers).uniq if is_creator_discussion?
        @notifiers.delete $config.default_email_reciver
      end

      def resolve_notifiers
        return if !@creator
        set_notifiers
        @notifiers.each do |email|
          if !@organization.has_member?(email)
            is_registered_user = User.already_register?(email)
            @organization.invite_user(email)
            EmailEngine::InvitationNotifier.new(email, @organization, @creator, is_registered_user).invitation_notification
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
