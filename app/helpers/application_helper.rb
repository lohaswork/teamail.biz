module ApplicationHelper
  def display_notice_and_alert
      msg = ''
      msg << (content_tag :div, notice, :class => "notice") if notice
      msg << (content_tag :div, alert, :class => "alert") if alert
      sanitize msg
  end
end
