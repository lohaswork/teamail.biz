# encoding: utf-8
class Organization < ActiveRecord::Base
  attr_accessible :email, :name
  has_and_belongs_to_many :users
  validates :name, presence: true, :uniqueness => {:case_sensitive => false, :message => "组织名已使用"}

end
