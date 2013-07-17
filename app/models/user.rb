# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :active_status, :authority_type, :email, :name, :online_status,\
                 :password, :remember_token, :active_code

  has_many :organization_memberships
  has_many :organizations, :through => :organization_memberships
  before_create :add_active_code

  before_validation(:on=>:create) { |user| user.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :uniqueness =>{:message=>'邮件地址已使用'}, :presence => {:message=>'请输入邮件地址'}, :format => {:with => VALID_EMAIL_REGEX, :message=>'邮件地址不合法'}
  validates :password, :length => { :minimum =>6, :message => '密码至少需要六位' }

  def self.create_with_organization(user, organization_name)
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

  private
  def add_active_code
    self.active_code = SecureRandom.urlsafe_base64
  end

end
