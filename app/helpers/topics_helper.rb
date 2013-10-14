module TopicsHelper
  def show_for_checkbox(users, topic)
    users.map { |user| { :email => user.email, :email_name => user.email_name, :is_in_topic => topic && topic.active_members.include?(user) || false } }
  end

  def order_by_updator(topics)
    unless topics.blank?
      topics.sort_by { |topic| topic.last_update_time }.reverse
    end
  end

  def login_user_has_archived?(topic)
    topic && topic.user_topics.find_by_user_id(login_user.id).archive_status == 1
  end
end
