# encoding: utf-8
class Organization < ActiveRecord::Base
  attr_accessible :name

  has_many :organization_memberships
  has_many :users, :through => :organization_memberships
  has_many :topics
  has_many :tags
  validates :name, presence: true, :uniqueness => { :case_sensitive => false, :message => "组织名已使用" }

  scope :for_user, lambda { |user| joins(:users).where("user_id = ?", user.id).readonly(false) }

  def add_tag(tag_name)
    tag = Tag.new(:name => tag_name)
    raise ValidationError.new(tag.errors.full_messages) if !tag.valid?
    tags << tag
    self
  end
end
