# encoding: utf-8
class Topic < ActiveRecord::Base
  attr_accessible :title

  belongs_to :organization
  has_many :discussions, :as => :discussable, :order => "updated_at asc", :uniq => true
  has_many :user_topics
  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings, :uniq => true
  has_many :users, :through => :user_topics, :uniq => true
  validates :title, :presence => { :message=>'请输入标题' }

  class << self
    def create_topic(title, content, emails, organization, current_user)
      topic = new(:title => title)
      raise ValidationError.new(topic.errors.full_messages) if !topic.valid?
      content = content.blank? ? "如题" : content
      topic.organization = organization
      Discussion.create_discussion(current_user, topic, emails, content)
      topic
    end
  end

  def add_taggings(ids)
    tags = ids.map { |id| Tag.find(id) }
    tags.map { |tag| self.tags << tag }
    self
  end

  def remove_tagging(id)
    tag = Tag.find(id)
    self.tags.delete(tag)
    self
  end

  def has_tagging?(id)
    tag = Tag.find(id)
    self.tags.include?(tag)
  end

  def last_active_time
    discussions.last.updated_at
  end

  def last_updator
    User.find(discussions.last.user_from)
  end

  def creator
    discussions.first.creator
  end

  def content
    discussions.first.content
  end

  def active_members
    discussions.last.users
  end
end
