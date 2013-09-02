# encoding: utf-8
class Discussion < ActiveRecord::Base
  attr_accessible :content

  belongs_to :topic
  has_many :user_discussions
  has_many :users, :through => :user_discussions, :uniq => true
  validates :content, :presence => {:message => "请输入回复内容"}

  class << self
    def create_discussion(user_id, topic_id, content)
      discussion = new(:content => content)
      raise ValidationError.new(discussion.errors.full_messages) if !discussion.valid?
      discussion.creator = User.find(user_id)
      discussion.topic = Topic.find(topic_id)
      discussion.save
      discussion
    end

    def create_with_topic(user_id, topic, emails, content)
      discussion = Discussion.new(:content=>content)
      raise ValidationError.new(discussion.errors.full_messages) if !discussion.valid?
      topic.discussions << discussion
      topic.save
      selected_users = emails.map{|email| User.find_by_email email}
      current_user = User.find(user_id)
      discussion.creator = current_user
      discussion.users << (selected_users << current_user)
      discussion.save
      discussion
    end
  end

  def creator
    User.find(user_from)
  end

  def creator=(user)
    self.user_from = user.id
  end
end
