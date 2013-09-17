# encoding: utf-8
class Tag < ActiveRecord::Base
  attr_accessible :color, :name

  belongs_to :organization
  validates :name, presence: true, :uniqueness => {:case_sensitive => true, :message => "标签名已使用"}

  class << self
    def create_with_organization(tag_name, organization)
      tag = Tag.new(:name => tag_name)
      raise ValidationError.new(tag.errors.full_messages) if !tag.valid?
      organization.tags << tag
      organization.save
      tag
    end
  end
end
