# encoding: utf-8
require 'bcrypt'
class User < ActiveRecord::Base
  attr_accessible :email, :password

  has_many :organization_memberships
  has_many :organizations, -> { uniq }, :through => :organization_memberships
  has_many :user_topics
  has_many :topics, -> { uniq }, :through => :user_topics
  has_many :user_discussions
  has_many :discussions, -> { uniq }, :through => :user_discussions
  before_create :add_active_code, :create_remember_token

  before_validation(:on=>:create) { |user| user.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => { :message=>'请输入邮件地址' },
    :format => { :with => VALID_EMAIL_REGEX, :message=>'邮件地址不合法', :allow_blank => true },
    :uniqueness => { :message=>'邮件地址已使用' }

  validates :password, :length => { :minimum => 6, :message => '密码至少需要六位' }

  class << self
    def create_with_organization(user, organization_name)
      user = User.new(:email => user[:email], :password => user[:password])
      raise ValidationError.new(user.errors.full_messages) if !user.valid?
      organization = Organization.new(:name => organization_name)
      raise ValidationError.new(organization.errors.full_messages)if !organization.valid?
      organization.save!
      user.organizations << organization
      user.default_organization = organization
      user.save!
      organization.membership(user).update_attribute(:authority_type, 1)
      user
    end

    def authentication(email, password)
      user = email && self.find_by_email(email)
      if !user
        error_message = "没有这个用户"
      elsif !user.active_status?
        error_message = "您的账户尚未激活"
      elsif user.password != password
        error_message = "密码或邮件地址不正确"
      end
      raise(ValidationError.new(error_message)) if error_message
      user
    end

    def forgot_password(email)
      user = self.find_by_email(email) if !email.blank?
      raise ValidationError.new('您的邮件地址不正确') if !user
      user.generate_reset_token
      ResetPasswordNotifierWorker.perform_async(user.id)
      user
    end

    def reset_password(reset_token, password)
      begin
        user = self.find_by_reset_token(reset_token)
        user.password = password
        user.save!
        user.update_attribute(:reset_token, nil)
        user.update_attribute(:active_status, 1) if user.active_status != 1
      rescue
        raise ValidationError.new(user.errors.full_messages)
      end
    end

    def generate_init_password
      SecureRandom.urlsafe_base64
    end

    def already_register?(email)
      !!self.find_by_email(email)
    end

    def check_emails_validation(invited_emails)
      invited_emails.each do |invited_email|
        unless User.already_register?(invited_email)
          user = User.new(:email => invited_email, :password => User.generate_init_password)
          raise ValidationError.new(user.errors.full_messages) unless user.valid?
        end
      end
    end
  end

  def password
    @password ||= BCrypt::Password.new(password_digest)
  end

  def password=(unencrypted_password)
    @password = unencrypted_password
    unless unencrypted_password.blank?
      self.password_digest = BCrypt::Password.create(unencrypted_password)
    end
  end

  def is_admin?(organization)
    organization.membership(self).authority_type == 1
  end

  def generate_reset_token
    generate_token(:reset_token)
    save
  end

  def activate!
    active_status? ? false : update_attribute(:active_status, true)
  end

  def email_name
    email[/[^@]+/]
  end

  def default_organization=(organization)
    self.default_organization_id = organization.id
  end

  def default_organization
    default_organization_id && Organization.find(default_organization_id)
  end
  private
  def create_remember_token
    generate_token(:remember_token)
  end

  def add_active_code
    generate_token(:active_code)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
