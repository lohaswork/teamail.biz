# encoding: utf-8
class Discussion < ActiveRecord::Base
  belongs_to :topic
  has_many :user_discussions
  has_many :users, :through => :user_discussions
end
