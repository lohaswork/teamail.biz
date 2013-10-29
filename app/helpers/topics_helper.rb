module TopicsHelper
  def show_for_checkbox(users, topic)
    users.map { |user| {
      :email => user.email,
      :email_name => user.active_status ? user.email_name : user.email,
      :is_in_topic => topic && topic.default_notify_members.include?(user) || false } }
  end

  def order_by_updator(topics)
    begin
      topics.sort_by { |topic| topic.last_update_time }.reverse
    rescue NoMethodError
      nil
    end
  end

  def archive_disabled?(topic)
    if topic && topic.get_relation_with(login_user) && topic.archive_status_of(login_user) !=1
      false
    else
      true
    end
  end

  def display_unread_style?(topic)
    in_personal_topics_page? && topic.read_status_of(login_user) != 1 || false
  end

  def unread_topic_number
    login_user.topics.reject { |topic| topic.archive_status_of(login_user) == 1 }
    .reject { |topic| topic.read_status_of(login_user) == 1 }
    .length
  end

  private
  def in_personal_topics_page?
    current_page?(:controller => 'topics', :action => 'unarchived') || current_page?(:controller => 'users', :action => 'topics') || false
  end
end
