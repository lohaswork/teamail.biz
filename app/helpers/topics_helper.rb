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
                      'h1' => ['style'],
                      'h2' => ['style'],
                      'h3' => ['style'],
                      'h4' => ['style'],
                      'h5' => ['style'],
                      'h6' => ['style'],
                      'img' => ['alt', 'src', 'title', 'style'] },
      :protocols => { 'a' => { 'href' => ['http', 'https', 'mailto'] },
                      'img' => { 'src'  => ['http', 'https', :relative] }
      })
  end

  def show_for_checkbox(users, topic)
    users.map do |user| {
      :email => user.email,
      :display_name => user.display_name,
      :formal? => user.formal_type?,
      :is_in_topic => topic && topic.default_notify_members.include?(user) || false
    }
    end
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
    topic.read_status_of_user(login_user) ? "read" : "unread"
  end

  def in_personal_topics_page?
    current_page?(:controller => 'topics', :action => 'unarchived') || current_page?(:controller => 'users', :action => 'topics') || false
  end
end
