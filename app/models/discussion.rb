# encoding: utf-8
class Discussion < ActiveRecord::Base
  attr_accessible :content

  belongs_to :discussable, :polymorphic => true
  has_many :user_discussions
  has_many :users, :through => :user_discussions, :uniq => true
  validates :content, :presence => { :message => "请输入回复内容" }
  after_create :update_topic_members

  class << self
    def create_discussion(login_user, topic, emails, content)
      discussion = Discussion.new(:content=>content)
      raise ValidationError.new(discussion.errors.full_messages) if !discussion.valid?
      selected_users = emails.map { |email| User.find_by_email email }
      discussion.notify_party = selected_users
      discussion.creator = login_user
      discussion.users << (selected_users << login_user)
      topic.discussions << discussion
      topic.save!
      topic.unarchived_by_update
      discussion
    end
  end

  def creator
    User.find(user_from)
  end

  def notify_party=(users)
    self.user_to = users.map { |user| user.id }.join(',')
    users
  end

  # Not used for now until email receiver features add
  #def notify_party
  #  self.user_to.split(',').map { |id| User.find id }
  #end

  def creator=(user)
    self.user_from = user.id
  end

  private

  def update_topic_members
    discussable.users << users
  end

end
