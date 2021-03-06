# encoding: utf-8
class EarlyAdopter < ActiveRecord::Base
  attr_accessible :email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :uniqueness => { :message =>'邮件地址已使用' }, :presence => { :message =>'请输入邮件地址' }, :format => { :with => VALID_EMAIL_REGEX, :message =>'邮件地址不合法' }

  def self.create_early_adopter(email)
    early_adopter = self.new(email:email)
    begin
      early_adopter.save!
    rescue
      raise ValidationError.new(early_adopter.errors.messages.values)
    end
  end
end
