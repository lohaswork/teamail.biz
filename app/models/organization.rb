# encoding: utf-8
class Organization < ActiveRecord::Base
  attr_accessible :name

  has_many :organization_memberships
  has_many :users, :through => :organization_memberships
  has_many :topics
  has_many :tags
  validates :name, presence: true, :uniqueness => { :case_sensitive => false, :message => "组织名已使用" }

  scope :for_user, lambda { |user| joins(:users).where("user_id = ?", user.id) }

  def topics_by_active_time
    self.topics.sort_by { |topic| topic.last_active_time }.reverse
  end

  def add_tag(tag_name)
    tag = Tag.new(:name => tag_name)
    raise ValidationError.new(tag.errors.full_messages) if !tag.valid?
    organization = Organization.find_by_id(self.id)
    organization.tags << tag
    organization.save!
    organization
  end

  # 有待重构
  def topics_add_taggings(selected_topics_ids, selected_tags_ids)
    selected_topics_ids = selected_topics_ids.map { |id| id.to_i }
    self.topics.map do |topic|
      selected_topics_ids.include?(topic.id) ? topic.add_taggings(selected_tags_ids) : topic
    end
    self.topics
  end
end
