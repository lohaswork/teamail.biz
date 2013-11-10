require 'sanitize'
module TopicsHelper
  def safe_content(content)
    Sanitize.clean(content, Sanitize::Config::RELAXED)
  end

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

  def read_style(topic)
    if UserDiscussion.where(discussion_id: topic.discussions.last.id, user_id: login_user.id).exists? && topic.read_status_of(login_user) != 1
      "unread"
    else
      "read"
    end
  end

  def has_attachments?(topic)
    arr = topic.discussions.map { |discussion| discussion.upload_files.length }
    arr.delete 0
    !arr.blank?
  end

  def unread_topic_number
    login_user.topics.reject { |topic| topic.archive_status_of(login_user) == 1 }
    .reject { |topic| topic.read_status_of(login_user) == 1 }
    .length
  end

  def in_personal_topics_page?
    current_page?(:controller => 'topics', :action => 'unarchived') || current_page?(:controller => 'users', :action => 'topics') || false
  end
end
