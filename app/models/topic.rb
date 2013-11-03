# encoding: utf-8
class Topic < ActiveRecord::Base
  attr_accessible :title

  # Paginate
  paginates_per 30

  belongs_to :organization
  has_many :discussions, lambda { order('updated_at asc').uniq }, :as => :discussable
  has_many :user_topics
  has_many :taggings, :as => :taggable
  has_many :tags, lambda { uniq }, :through => :taggings
  has_many :users, lambda { uniq }, :through => :user_topics

  validates :title, :presence => { :message=>'请输入标题' }

  scope :order_by_update, lambda { order('updated_at DESC') }
  scope :get_unarchived, lambda { |user| joins(:user_topics).where("user_topics.user_id = ? AND IFNULL( user_topics.archive_status, 0 ) <> 1 ", user.id) }

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

  def has_tags?(ids)
    return true if ids.each do |id|
      tag = Tag.find(id)
      break unless self.tags.include?(tag)
    end
  end

  def get_relation_with(user)
    self.user_topics.find_by_user_id(user.id)
  end

  def archive_status_of(user)
    self.get_relation_with(user).archive_status
  end

  def archived_by(user)
    begin
      self.user_topics.find_by_user_id(user.id).update_attribute(:archive_status, true)
    rescue ActiveRecord::RecordNotFound
      nil
    end
    self
  end

  def unarchived_by_others
    self.users.reject { |user| user.id == self.last_updator.id }.each { |user| self.user_topics.find_by_user_id(user.id).update_attribute(:archive_status, false) }
  end

  def mark_as_unread_to_others
    self.users.reject { |user| user.id == self.last_updator.id }.each { |user| self.discussions.last.mark_as_unread_by(user) }
  end

  def read_status_of(user)
    self.discussions.last.read_status_of(user)
  end

  def last_update_time
    updated_at
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

  def default_notify_members
    members = discussions.last.notify_party.compact
    members << discussions.last.creator
  end
end
