module TopicsHelper
  def show_for_checkbox(users, topic)
    users.map { |user| { :email => user.email, :email_name => user.email_name, :is_in_topic => topic && topic.active_members.include?(user) || false } }
  end

  def topic_with_tags(topics)
    topics.map { |topic| { :id=> topic.id, :updator => topic.last_updator.email_name, :size => topic.discussions.size, :title => topic.title, :tags => topic.tags, :active_time => topic.last_active_time } }
  end
end
