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

  scope :get_archived, lambda { |user| joins(:user_topics).where( :user_topics => { :user_id => user.id, :archive_status => true } ) }
  scope :get_unarchived, lambda { |user| joins(:user_topics).where( "user_topics.user_id = ? AND IFNULL( user_topics.archive_status, 0 ) <> 1 ", user.id ) }

  class << self
    def create_topic(title, content, emails, organization, login_user)
      topic = new(:title => title)
      raise ValidationError.new(topic.errors.full_messages) if !topic.valid?
      content = content.blank? ? "如题" : content
      topic.organization = organization
      Discussion.create_discussion(login_user, topic, emails, content)
      topic
    end
  end

  def relations_with(user)
    self.user_topics.find_by_user_id(user.id)
  end

  def add_tags(ids)
    tags = ids.map { |id| Tag.find(id) }
    tags.map { |tag| self.tags << tag }
    self
  end

  def remove_tag(id)
    tag = Tag.find(id)
    self.tags.delete(tag)
    self
  end

  def has_tag?(id)
    tag = Tag.find(id)
    self.tags.include?(tag)
  end

  def archived_by(user)
    begin
      self.user_topics.find_by_user_id(user.id).update_attribute(:archive_status, true)
    rescue
      nil
    end
    self
  end

  def unarchived_by_update
    self.users.reject { |user| user.id == self.last_updator.id }
              .each { |user| self.user_topics.find_by_user_id(user.id).update_attribute(:archive_status, false) }
  end

  def last_update_time
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
