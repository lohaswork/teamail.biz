# encoding: utf-8
class Topic < ActiveRecord::Base

  belongs_to :organization
  has_many :user_topics
  has_many :users, :through => :user_topics
  validates :title, presence: true
end
