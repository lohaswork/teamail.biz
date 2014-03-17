# encoding: utf-8
class Discussion < ActiveRecord::Base
  attr_accessible :content

  belongs_to :discussable, :polymorphic => true
  has_many :upload_files
  has_many :user_discussions
  has_many :users, lambda { uniq }, :through => :user_discussions
  validates :content, :presence => { :message => "请输入回复内容" }

  after_create :update_topic_member

  class << self
    def create_discussion(user, topic, emails, content)
      discussion = Discussion.new(:content => content)
      raise ValidationError.new(discussion.errors.messages.values) if !discussion.valid?
      selected_users = emails.map { |email| User.find_by_email email }
      discussion.notify_party = selected_users
      discussion.creator = user
      discussion.users << (selected_users << user)
      topic.discussions << discussion
      topic.new_record? ? topic.save! : topic.touch
      discussion.mark_as_read_by_user(user)
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

  def read_status_of_user(user)
    begin
      self.user_discussions.find_by_user_id(user.id).read_status == 1 ? true : false
    rescue ActiveRecord::RecordNotFound, NoMethodError
      false
    end
  end

  def mark_as_read_by_user(user)
    begin
      self.user_discussions.where(:user_id => user.id).first_or_create.update_attribute(:read_status, true)
    rescue ActiveRecord::RecordNotFound, NoMethodError
      nil
    end
    self
  end

  def mark_as_unread_by_user(user)
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

  def add_files(files)
    files.each do |id|
      file = UploadFile.find_by(id: id)
      self.upload_files << file unless file.blank?
    end
    self.save!
  end

  private
  def update_topic_member
    discussable.users << (users - discussable.users)
  end
end
