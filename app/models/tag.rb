class Tag < ActiveRecord::Base
  attr_accessible :color, :name

  belongs_to :organization
end
