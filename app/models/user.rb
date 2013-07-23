# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :active_status, :authority_type, :email, :name, :online_status,\
                 :password, :remember_token, :active_code, :reset_token

  has_many :organization_memberships
  has_many :organizations, :through => :organization_memberships
  before_create :add_active_code, :create_remember_token

  before_validation(:on=>:create) { |user| user.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :uniqueness =>{:message=>'邮件地址已使用'}, :presence => {:message=>'请输入邮件地址'}, :format => {:with => VALID_EMAIL_REGEX, :message=>'邮件地址不合法'}
  validates :password, :length => { :minimum =>6, :message => '密码至少需要六位' }

  class << self
    def create_with_organization(user, organization_name)
      user = User.new(:email => user[:email], :password => user[:password])
      if user.valid?
        organ = Organization.create!(:name => organization_name)
        user.organizations << organ
        user.save!
        user
      else
        raise ActiveRecord::RecordInvalid, user
      end
    end

    def authentication(email, password)
      user = email && self.find_by_email(email)
      raise ValidationError.new("信息不正确") unless user && user.password == password
      user
    end

    def forgot_password(email)
      user = self.find_by_email(email) if !email.blank?
      raise ValidationError.new('您的邮件地址不正确') if !user
      user.generate_reset_token
      EmailEngine::ResetPasswordNotifier.new(user).reset_password_notification
    end

    def reset_password(reset_token, password)
      user = self.find_by_reset_token(reset_token)
      user.password = password
      user.save!
      user.update_attribute(:reset_token, nil)
    end

  end

  def generate_reset_token
    generate_token(:reset_token)
    save
  end

  def activate!
   active_status? ? false : update_attribute(:active_status, true)
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
