class Tag < ActiveRecord::Base
  attr_accessible :color, :name

  belongs_to :organization

  class << self
    def create_with_organization(tag_name, organization)
      tag = Tag.new(:name => tag_name)
      organization.tags << tag
      organization.save
      tag
    end
  end
end
