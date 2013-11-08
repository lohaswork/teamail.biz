  # encoding: utf-8
module EmailEngine
  module EmailReceiver

    module EmailContentResolution
      extend ActiveSupport::Concern

      def analyzed_title
        title_array = subject.gsub(/\s+/m, ' ').strip.split(' ')
        tag_set = Set.new
        title_array.map { |segment| tag_set.add? segment if /^#/.match segment }
        @tags = tag_set.to_a.map { |tag| tag[1..-1] }
        title_content = (title_array - tag_set.to_a).join(' ')
      end

      def analyzed_content
        if self.respond_to? :body_html
          body_html
        elsif self.respond_to? :stripped_text
          stripped_text
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
        set_notifiers
      end

      def resolve_topic_of_email
        topic_id = body_html[/#{Regexp.escape(@gateway.host_name)}\/topics\/(.*?)\"/m, 1]
        topic_id = topic_id.blank? ? nil : topic_id.to_i
        topic_id && Topic.find(topic_id)
      end

      def set_notifiers
        email_regex = /\b[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\b/i
        @notifiers = []
        all_recipient_emails = to + "," + (self.methods.include?(:cc) ? self.cc : '')
        all_recipient_emails.split(',').map{ |address| @notifiers.concat( address.scan(email_regex) ) }
        @notifiers = (@topic.default_notify_members.map(&:email) + @notifiers).uniq if is_creating_discussion
        @notifiers.delete @creator.email
        @notifiers.delete $config.default_system_email
      end
    end

  end
end
