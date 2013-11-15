# encoding: utf-8
class Discussion < ActiveRecord::Base
  attr_accessible :content

  belongs_to :discussable, :polymorphic => true
  has_many :upload_files
  has_many :user_discussions
  has_many :users, lambda { uniq }, :through => :user_discussions
  validates :content, :presence => { :message => "请输入回复内容" }
  after_create :update_topic_members
  after_touch :update_topic_members

  class << self
    def create_discussion(login_user, topic, emails, content)
      discussion = Discussion.new(:content => content)
      raise ValidationError.new(discussion.errors.full_messages) if !discussion.valid?
      selected_users = emails.map { |email| User.find_by_email email }
      discussion.notify_party = selected_users
      discussion.creator = login_user
      discussion.users << (selected_users << login_user)
      topic.discussions << discussion
      topic.new_record? ? topic.save! : topic.touch
      discussion.mark_as_read_by(login_user)
      topic.unarchived_by_others
      topic.mark_as_unread_to_others
      discussion
    end
  end

  def creator
    User.find(user_from)
  end

  def creator=(user)
    self.user_from = user.id
  end

  def read_status_of(user)
    begin
      self.user_discussions.find_by_user_id(user.id).read_status
    rescue ActiveRecord::RecordNotFound, NoMethodError
      false
    end
  end

  def mark_as_read_by(user)
    begin
      self.user_discussions.where(:user_id => user.id).first_or_create.update_attribute(:read_status, true)
    rescue ActiveRecord::RecordNotFound, NoMethodError
      nil
    end
    self
  end

  def mark_as_unread_by(user)
    begin
      self.user_discussions.where(:user_id => user.id).first_or_create.update_attribute(:read_status, false)
    rescue ActiveRecord::RecordNotFound, NoMethodError
      nil
    end
    self
  end

  def notify_party=(users)
    self.user_to = users.map { |user| user.id }.join(',')
    users
  end

  def notify_party
    if self.user_to.blank?
      []
    else
      self.user_to.split(',').map { |id| User.find id }
    end
  end

  private

  def update_topic_members
    discussable.users << users
  end
end
