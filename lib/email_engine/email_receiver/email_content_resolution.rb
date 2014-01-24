  # encoding: utf-8
module EmailEngine
  module EmailReceiver

    module EmailContentResolution
      extend ActiveSupport::Concern

      include TextRegexp::TopicAnalysis

      def topic_title_from_email
        title, @tags = analyzed_title(subject)
        title
      end

      def analyzed_content
        if self.respond_to?(:body_html) && !body_html.blank?
          body_html
        elsif self.respond_to?(:body_plain) && !body_plain.blank?
          simple_format_with_quote body_plain
        else
          "此封内容为空"
        end
      end

      def resolve_email
        @topic = resolve_topic_of_email
        @creator = User.find_by_email sender
        @is_creating_discussion = !!@topic  #set if we are creating discussion or a topic
        if is_creating_discussion
          @organization = @topic.organization
        else
          @organization = @creator && @creator.default_organization
        end
        emails = get_recipient_emails_to_array
        if @creator && @organization && @organization
          @organization.add_informal_member(emails)
        end
        set_notifiers(emails)
      end

      def resolve_topic_of_email
        topic_id = nil
        [:in_reply_to, :reference, :body_html, :body_plain].each do |exp_body|
          self.send(exp_body).scan(/#{Regexp.escape(@gateway.host_name(false))}\/topics\/(\d+)/m) { |id| topic_id = id.join("").to_i } if self.respond_to? exp_body
          break if topic_id
        end
        topic_id && Topic.find(topic_id)
      end

      def set_notifiers(emails)
        @notifiers = []
        emails.map do |email|
          @notifiers.concat email if @organization && @organization.has_member?(email)
        end
        @notifiers = (@topic.default_notify_members.map(&:email) + @notifiers).uniq if is_creating_discussion
        @notifiers.delete sender
        @notifiers.delete $config.default_system_email
      end

      def get_recipient_emails_to_array
        email_regex = /\b[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\b/i
        all_recipient_emails = to + "," + (self.methods.include?(:cc) ? self.cc : '')
        emails = all_recipient_emails.split(',').map do |address|
          email = address.scan(email_regex).downcase
        end
        emails = emails.uniq
      end

      private
      # Need to add blockquote to reference
      def simple_format_with_quote(text)
        text = '' if text.nil?
        text = text.dup
        start_tag = "<p>"
        text = text.to_str
        text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
        text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
        text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
        text.insert 0, start_tag
        text.concat("</p>")
      end
    end

  end
end
