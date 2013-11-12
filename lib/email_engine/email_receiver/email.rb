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
        invite_notifiers
        if is_creating_discussion
          content = analyzed_content
          discussion = Discussion.create_discussion(@creator, @topic, @notifiers, content)
          post_attachments_to_oss(discussion) if self.has_attachments?
          EmailEngine::DiscussionNotifier.new(discussion.id, @notifiers).create_discussion_notification
        else
          title = subject.blank? ? "此主题标题为空" : analyzed_title
          @topic = Topic.create_topic(title, analyzed_content, @notifiers, @organization, @creator)
          add_tags_to(@topic)
          post_attachments_to_oss(@topic.discussions.first) if self.has_attachments?
          EmailEngine::TopicNotifier.new(@topic.id, @notifiers).create_topic_notification
        end
      end

      protected

      def invite_notifiers
        @notifiers.each do |email|
          if !@organization.has_member?(email)
            is_registered_user = User.already_register?(email)
            @organization.invite_user(email)
            EmailEngine::InvitationNotifier.new(email, @organization, @creator.email, is_registered_user).invitation_notification
          end
        end
      end

      def add_tags_to(topic)
        valid_tags = @tags.map do |tag|
          if topic.organization.tags.include?(tag) || !Tag::VALID_TAGNAME_TEGEX.match(tag)
            nil
          else
            tag = Tag.new(:name => tag)
            topic.organization.tags << tag
            tag.id
          end
        end
        topic.add_tags(valid_tags.compact)
      end
    end

  end
end
