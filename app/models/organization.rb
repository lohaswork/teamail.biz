class Organization < ActiveRecord::Base
  attr_accessible :email, :name
  has_many :user
  before_validation(:on=>:create) { |user| user.name = name.downcase }
  validates :name, presence: true, uniqueness: true
  validates_presence_of :name
  validates_uniqueness_of :name

end
