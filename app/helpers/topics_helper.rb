module TopicsHelper
  def show_for_checkbox(users, topic)
    users.map { |user| { :email => user.email, :email_name => user.email_name, :is_in_topic => topic && topic.active_members.include?(user) || false } }
  end

  def order_by_updator(topics)
    begin
      topics.sort_by { |topic| topic.last_update_time }.reverse
    rescue NoMethodError
      nil
    end
  end

  def archive_disabled?(topic)
    if topic && topic.relations_with(login_user) && topic.relations_with(login_user).archive_status !=1
      false
    else
      true
    end
  end

  def display_unread_style?(topic)
    in_personal_topics_page? && topic.read_status_of(login_user) != 1 || false
  end

  private
  def in_personal_topics_page?
    current_page?(:controller => 'topics', :action => 'unarchived') || current_page?(:controller => 'users', :action => 'topics') || false
  end
end
