class Organization < ActiveRecord::Base
  attr_accessible :email, :name
  has_many :user


end
