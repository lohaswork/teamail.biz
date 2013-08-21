# encoding: utf-8
class Organization < ActiveRecord::Base
  attr_accessible :name
  has_many :organization_memberships
  has_many :users, :through => :organization_memberships
  has_many :topics
  validates :name, presence: true, :uniqueness => {:case_sensitive => false, :message => "组织名已使用"}

  scope :for_user, lambda { |user| joins(:users).where("user_id = ?", user.id)}

  def topics_by_active_time
    self.topics.sort_by{|topic|topic.last_active_time}.reverse
  end
end
