# encoding: utf-8
class Topic < ActiveRecord::Base
  attr_accessible :title

  belongs_to :organization
  has_many :discussions, :order => "updated_at asc"
  has_many :user_topics
  has_many :users, :through => :user_topics
  validates :title, :presence => {:message=>'请输入标题'}

  class << self
    def create_topic(title, content, organization_id, user_id)
      topic = new(:title => title)
      current_user = User.find(user_id)
      topic.organization = Organization.find(organization_id)
      topic.users << current_user
      raise ValidationError.new(topic.errors.full_messages) if !topic.valid?
      content = content.blank? ? "如题" : content
      discussion = Discussion.new(:content=>content)
      raise ValidationError.new(discussion.errors.full_messages) if !discussion.valid?
      discussion.creator = current_user
      discussion.save
      topic.discussions << discussion
      topic.save
      topic
    end
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
end
