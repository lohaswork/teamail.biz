# encoding: utf-8
class Organization < ActiveRecord::Base
  attr_accessible :name

  has_many :organization_memberships
  has_many :users, :through => :organization_memberships
  has_many :topics
  has_many :tags
  validates :name, presence: true, :uniqueness => { :case_sensitive => false, :message => "组织名已使用" }

  scope :for_user, lambda { |user| joins(:users).where("user_id = ?", user.id).readonly(false) }

  def topics_by_active_time
    self.topics.sort_by { |topic| topic.last_active_time }.reverse
  end

  def add_tag(tag_name)
    tag = Tag.new(:name => tag_name)
    raise ValidationError.new(tag.errors.full_messages) if !tag.valid?
    tags << tag
    self
  end

  def cut_down(user_id)
    user = User.find(user_id)
    self.users.delete(user)
    user.default_organization_id = user.organizations.first if user.default_organization_id == self.id
    user.save
    self
  end

  def invite_user(email)
    unless user = User.find_by_email(email)
      user = User.new(:email => email, :password => User.generate_init_password)
      raise ValidationError.new(user.errors.full_messages) if !user.valid?
    user.generate_reset_token
    end
    user.organizations << self
    user.default_organization_id = self.id if user.default_organization.blank?
    user.save!
    self
  end
end
