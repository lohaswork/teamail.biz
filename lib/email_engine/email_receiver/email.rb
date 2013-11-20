  # encoding: utf-8
module EmailEngine
  module EmailReceiver

    class Email
      attr_reader :is_creating_discussion

      include EmailEngine::EmailReceiver::EmailContentResolution
      include EmailEngine::EmailReceiver::AttachmentHandler
      include EmailEngine::EmailReceiver::Notifier

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

      def create_from_email
        resolve_email
        invalid_creator_notification && return if !@organization || is_creating_discussion && !@organization.has_member?(sender)
        if is_creating_discussion
          content = analyzed_content
          discussion = Discussion.create_discussion(@creator, @topic, @notifiers, content)
          begin
            post_attachments_to_oss(discussion) if self.has_attachments?
            EmailEngine::DiscussionNotifier.new(discussion.id, @notifiers).create_discussion_notification
          rescue
            raise Exceptions::PostEmailReceiveError
          end
        else
          title = subject.blank? ? "此主题标题为空" : topic_title_from_email
          email_title = subject
          @topic = Topic.create_topic(title, email_title, analyzed_content, @notifiers, @organization, @creator)
          begin
            add_tags_from_title(@topic, @tags)
            post_attachments_to_oss(@topic.discussions.first) if self.has_attachments?
            EmailEngine::TopicNotifier.new(@topic.id, @notifiers).create_topic_notification
          rescue
            raise Exceptions::PostEmailReceiveError
          end
        end
      end

    end

  end
end
