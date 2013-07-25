# encoding: utf-8
class Topic < ActiveRecord::Base
  attr_accessible :title, :organization_id

  belongs_to :organization
  has_many :user_topics
  has_many :users, :through => :user_topics
  validates :name, presence: true
end
