class Organization < ActiveRecord::Base
  attr_accessible :email, :name
  has_and_belongs_to_many :users
  before_validation(:on=>:create) { |organization| organization.name = name.downcase }
  validates :name, presence: true, uniqueness: true

end
