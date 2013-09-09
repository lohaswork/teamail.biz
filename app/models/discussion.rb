# encoding: utf-8
class Discussion < ActiveRecord::Base
  attr_accessible :content

  belongs_to :topic
  has_many :user_discussions
  has_many :users, :through => :user_discussions, :uniq => true
  validates :content, :presence => {:message => "请输入回复内容"}
  after_create :update_topic_members

  class << self
    def create_discussion(current_user, topic, emails, content)
      discussion = Discussion.new(:content=>content)
      raise ValidationError.new(discussion.errors.full_messages) if !discussion.valid?
      selected_users = emails.map{|email| User.find_by_email email}
      discussion.creator = current_user
      discussion.users << (selected_users << current_user)
      topic.discussions << discussion
      topic.save
      discussion
    end
  end

  def creator
    User.find(user_from)
  end

  def creator=(user)
    self.user_from = user.id
  end

  private

  def update_topic_members
    topic.users << users
  end

end
