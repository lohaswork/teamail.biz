# encoding: utf-8
class Topic < ActiveRecord::Base
  attr_accessible :title

  belongs_to :organization
  has_many :discussions
  has_many :user_topics
  has_many :users, :through => :user_topics
  validates :title, :presence => {:message=>'请输入标题'}

  class << self
    def create_topic(title, content, organization_id, user_id)
      topic = new(:title => title)
      current_user = User.find(user_id)
      topic.organization = Organization.find(organization_id)
      topic.users << current_user
      if topic.valid? && !content.blank?
        discussion = Discussion.create(:content=>content)
        discussion.creator = current_user
      end
      topic.discussions << discussion if discussion
      topic.save!
    end
  end
end
