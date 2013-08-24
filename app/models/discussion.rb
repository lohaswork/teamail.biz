# encoding: utf-8
class Discussion < ActiveRecord::Base
  attr_accessible :content

  belongs_to :topic
  has_many :user_discussions
  has_many :users, :through => :user_discussions
  validates :content, :presence => {:message => "请输入回复内容"}

  class << self
    def create_discussion(user_id, topic_id, content)
      discussion = new(:content => content)
      discussion.creator = User.find(user_id)
      discussion.topic = Topic.find(topic_id)
      discussion.save!
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
