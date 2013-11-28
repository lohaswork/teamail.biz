module ControllerModules::User
  extend ActiveSupport::Concern

  included do
    helper_method :login_user, :is_logged_in?, :login_user_admin?, :get_colleagues, :check_emails_validation
  end

  def get_colleagues
    current_organization.users.reject { |user| user.email == login_user.email }
  end

  def login_user=(user)
    @login_user = user
    cookies[:login_token] = user.remember_token
  end

  def login_user
    @login_user ||= cookies[:login_token] && ::User.find_by_remember_token(cookies[:login_token])
  end

  def is_logged_in?
    !!login_user
  end

  def login_user_admin?
    login_user.is_admin?(current_organization)
  end

  def check_emails_validation(invited_emails)
    invited_emails.each do |invited_email|
      raise ValidationError.new('Email 邮件地址不合法') unless User::VALID_EMAIL_REGEX =~ invited_email
    end
    invited_emails
  end

end
