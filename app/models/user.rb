# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :active_status, :authority, :email, :name, :online_status,\
                 :organization_id, :password, :remember_token
  belongs_to :organization
  validates_uniqueness_of :email
  validate :check_email
  validates_presence_of :password

  def self.create_with_organization(email, pwd, organization_name)
    user = User.new(:email => email, :password => pwd)
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
    email_validator = /^\b[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}\b$/i
    if email.blank?
      errors[:email] = "请输入邮件地址"
    elsif email !~ email_validator
      errors[:email] = "邮件地址不合法"
    end
  end

end
