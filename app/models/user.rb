# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :active_status, :authority_type, :email, :name, :online_status,\
                 :organization_id, :password, :remember_token
  belongs_to :organization
  validates_uniqueness_of :email
  validate :check_email
  validates :password, presence: true, length: { minimum: 6 }

  def self.create_with_organization(user, organization_name)
    user = User.new(:email => user[:email], :password => user[:password])
    if user.valid?
      organ = Organization.create!(:name => organization_name)
      user.organization_id = organ.id
      user.save!
      user
    else
      #TODO: need a exception type and validate need modulize
      raise "user not valid"
    end
  end

  protected

  def check_email
    email_validator = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    if email.blank?
      errors[:email] = "请输入邮件地址"
    elsif email !~ email_validator
      errors[:email] = "邮件地址不合法"
    end
  end

end
