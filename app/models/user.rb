# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :active_status, :authority_type, :email, :name, :online_status,\
                 :organization_id, :password, :remember_token, :active_code

  belongs_to :organization
  
  before_validation(:on=>:create) { |user| user.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, uniqueness: true, presence: true, :format => {:with => VALID_EMAIL_REGEX}
  validates :password, length: { minimum: 6 }

  def self.create_with_organization(user, organization_name)
    user = User.new(:email => user[:email], :password => user[:password], :active_code => SecureRandom.urlsafe_base64)
    if user.valid?
      organ = Organization.create!(:name => organization_name)
      user.organization_id = organ.id
      user.save!
      user
    else
      raise ActiveRecord::RecordInvalid, user
    end
  end
  
end
