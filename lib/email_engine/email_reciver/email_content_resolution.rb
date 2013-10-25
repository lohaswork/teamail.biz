  # encoding: utf-8
module EmailEngine
  module EmailReciver
    module EmailContentResolution

      def analyzed_title
        title_array = subject.gsub(/\s+/m, ' ').strip.split(' ')
        tag_set = Set.new
        title_array.map { |segment| tag_set.add? segment if /^#/.match segment }
        @tags = tag_set.to_a.map { |tag| tag[1..-1] }
        debugger
        title_content = (title_array - tag_set.to_a).join(' ')
      end

      def add_tags_to_topic
        valid_tags = @tags.map do |tag|
          unless @topic.organization.tags.include? tag
            tag = Tag.new(:name => tag)
            next if !tag.valid?
            @topic.organization.tags << tag
            tag.id
          end
        end
        @topic.add_tags(valid_tags)
      end

    end
  end
end
