require 'sanitize'
module TopicsHelper

  def safe_content(content)
    #content = Sanitize.clean(content, Sanitize::Config::RELAXED)
    content = Sanitize.clean(content,
      :elements => %w[
      a abbr b blockquote br cite code div dd dl dt em h1 h2 h3 h4 h5 h6 i img li mark ol p pre
      q s span small strike strong sub sup table tr td time u ul font],
      :attributes => { 'a' => ['href', 'title'],
                      'font' => ['face', 'color'],
                      'table' => ['style', 'cellspacing', 'cellpadding', 'border', 'align'],
                      'tr' => ['style', 'align'],
                      'td' => ['style', 'align', 'colspan'],
                      'div' => ['style'],
                      'span' => ['style'],
                      'p' => ['style'],
                      'img' => ['alt', 'src', 'title'] },
      :protocols => { 'a' => { 'href' => ['http', 'https', 'mailto'] },
                      'img' => { 'src'  => ['http', 'https'] }
      })
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
    num = Topic.get_unarchived(login_user).to_a.reject { |topic| topic.read_status_of(login_user) == 1 }.length.to_s
  end

  def in_personal_topics_page?
    current_page?(:controller => 'topics', :action => 'unarchived') || current_page?(:controller => 'users', :action => 'topics') || false
  end
end
