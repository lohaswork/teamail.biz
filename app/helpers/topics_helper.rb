module TopicsHelper
  def show_for_checkbox(users, topic)
    users.map { |user| { :email => user.email, :email_name => user.email_name, :is_in_topic => topic && topic.active_members.include?(user) || false } }
  end

  def order_by_updator(topics)
    begin
      topics.sort_by { |topic| topic.last_update_time }.reverse
    rescue
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
end
