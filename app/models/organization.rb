# encoding: utf-8
class Organization < ActiveRecord::Base
  attr_accessible :name

  has_many :organization_memberships
  has_many :users, lambda { uniq }, :through => :organization_memberships
  has_many :topics
  has_many :tags
  # Cancel validation of uniqueness of name
  validates :name, presence: true # :uniqueness => { :case_sensitive => false, :message => "组织名已使用" }

  scope :for_user, lambda { |user| joins(:users).where("user_id = ?", user.id).readonly(false) }

  def membership(user)
    self.organization_memberships.find_by_user_id(user.id)
  end

  def add_tag(tag_name)
    tag = Tag.new(:name => tag_name, :organization_id => self.id)
    raise ValidationError.new(tag.errors.messages.values) if !tag.valid?
    tag.save!
    self.save!
    self
  end

  def delete_user(user_id)
    user = User.find(user_id)
    self.users.delete(user)
    user.default_organization_id = user.organizations.first if user.default_organization_id == self.id
    user.save!
    self
  end

  def add_member_by(email)
    unless user = User.find_by_email(email)
      user = User.new(:email => email, :password => User.generate_init_password)
      raise ValidationError.new(user.errors.messages.values) if !user.valid?
      user.generate_reset_token
    end
    user.organizations << self
    user.default_organization_id = self.id if user.default_organization.blank?
    user.save!
    self
  end

  def has_member?(email)
    user = User.find_by_email(email)
    self.users.include? user
  end
end
