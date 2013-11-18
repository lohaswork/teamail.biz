  # encoding: utf-8
module TextRegexp

  module TopicAnalysis
    extend ActiveSupport::Concern

    def analyzed_title(subject)
      title_array = subject.gsub(/\s+/m, ' ').strip.split(' ')
      tag_set = Set.new
      title_subject = title_array.dup
      title_array.each do |segment|
        match_data = /^\[.*\]$/.match segment
        if match_data.blank?
          break
        else
          tag_arr = match_data[0].gsub(' ', '-').gsub(/[\[\]]+/m, ' ').split(' ')
          tag_arr.each { |tag| tag_set.add? tag }
          title_subject.delete segment
        end
      end
      tags = tag_set.to_a
      title_subject = title_subject.join(' ')
      return title_subject, tags
    end

    def add_tags_from_title(topic, tags)
      valid_tags = tags.map do |tag|
        if !Tag::VALID_TAGNAME_TEGEX.match(tag)
          nil
        elsif topic.organization.tags.map { |tag| tag.name}.include?(tag)
          tag =Tag.where(organization_id: topic.organization.id, name: tag).first
          tag.id
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
