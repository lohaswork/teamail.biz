# encoding: utf-8
class EarlyAdopter < ActiveRecord::Base
  attr_accessible :email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :uniqueness => {:message =>'邮件地址已使用'}, :presence => {:message =>'请输入邮件地址'}, :format => {:with => VALID_EMAIL_REGEX, :message =>'邮件地址不合法'}
end
