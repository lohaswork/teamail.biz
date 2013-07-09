# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessible :active_status, :authority_type, :email, :name, :online_status,\
                 :organization_id, :password, :remember_token

  belongs_to :organization
  has_one :active_code
  
  before_validation(:on=>:create) { |user| user.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, uniqueness: true, presence: true, :format => {:with => VALID_EMAIL_REGEX}
  validates :password, length: { minimum: 6 }

  def self.create_with_organization(user, organization_name)
    user = User.new(:email => user[:email], :password => user[:password])
    if user.valid?
      organ = Organization.create!(:name => organization_name)
      user.organization_id = organ.id
      user.save!
      user
    else
      raise ActiveRecord::RecordInvalid, user
    end
  end
  
  def create_active_code
    active_code = ActiveCode.new
    active_code.user_id = self.id
    active_code.code ||= Digest::MD5.hexdigest(rand(Time.now.to_i).to_s)
    active_code.save!
    active_code
  end
  
end
