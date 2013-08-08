# encoding: utf-8
class Topic < ActiveRecord::Base
  attr_accessible :title

  belongs_to :organization
  has_many :user_topics
  has_many :users, :through => :user_topics
  validates :title, :presence => {:message=>'请输入标题'}

  class << self
    def create_topic(title, organization_id, user_id)
      topic = new(:title => title)
      topic.organization = Organization.find(organization_id)
      topic.users << User.find(user_id)
      topic.save!
    end
  end
end
