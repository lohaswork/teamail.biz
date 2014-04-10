# encoding: utf-8
class Topic < ActiveRecord::Base
  attr_accessible :title, :email_title

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
  scope :filter_by_tags, lambda { |tags| find_by_sql(self.send(:tags_filter_sql, tags)) }

  class << self
    def create_topic(title, email_title=nil, content, emails, organization, user)
      topic = new(:title => title, :email_title => email_title)
      raise ValidationError.new(topic.errors.messages.values) if !topic.valid?
      content = content.blank? ? "如题" : content
      topic.organization = organization
      Discussion.create_discussion(user, topic, emails, content)
      topic
    end

    protected

    def tags_filter_sql(tags)
      tags = tags.is_a?(Array) ? tags : [tags]
      [
        "SELECT *
        FROM `topics`
        WHERE `id` IN (
          SELECT  `taggable_id`
          FROM `taggings`
          Where `taggable_id` = `topics`.`id`
          AND `taggable_type` = 'Topic'
          AND `tag_id` IN (?)
          GROUP BY taggable_id
          having count(*) = ?
          )
        ORDER BY updated_at DESC",
        tags,
        tags.size
      ]
    end
  end

  def informal_participators
    self.users.reject { |user| user.is_formal_member?(self.organization) }
  end

  def add_informal_member(emails)
    emails.each do |email|
      user = User.find_by(email: email)
      self.users << user unless self.users.include?(user)
    end
    self.save!
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
    tags = ids.map { |id| tag = Tag.find(id) }
    return true if tags.each { |tag| break unless self.tags.include?(tag) }
  end

  def get_relation_with(user)
    self.user_topics.find_by_user_id(user.id)
  end

  def archive_status_of(user)
    self.get_relation_with(user).archive_status
  end

  def archived_by_user(user)
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
    self.users.reject { |user| user.id == self.last_updator.id }.each { |user| self.discussions.last.mark_as_unread_by_user(user) }
  end

  def read_status_of_user(user)
    self.discussions.last.read_status_of_user(user)
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
    members = members.reject { |user| user.is_informal_member?(self.organization) }
  end

  def has_attachments?
    has_attachments = false
    Discussion.includes(:upload_files).where(discussable_id:id).each do |discussion|
      has_attachments |= discussion.has_attachments?
    end
    has_attachments
  end
end
