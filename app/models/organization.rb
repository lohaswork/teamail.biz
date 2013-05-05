class Organization < ActiveRecord::Base
  attr_accessible :email, :name
  has_many :user
  validates_presence_of :name
  validates_uniqueness_of :name

end
