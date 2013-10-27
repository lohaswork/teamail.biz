  # encoding: utf-8
module EmailEngine
  module Emailreceiver
    module EmailContentResolution

      def analyzed_title
        title_array = subject.gsub(/\s+/m, ' ').strip.split(' ')
        tag_set = Set.new
        title_array.map { |segment| tag_set.add? segment if /^#/.match segment }
        @tags = tag_set.to_a.map { |tag| tag[1..-1] }
        title_content = (title_array - tag_set.to_a).join(' ')
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
