# encoding: utf-8
class Organization < ActiveRecord::Base
  attr_accessible :name, :plan
  has_many :organization_memberships
  has_many :users, :through => :organization_memberships
  has_many :topics
  validates :name, presence: true, :uniqueness => {:case_sensitive => false, :message => "组织名已使用"}

end
