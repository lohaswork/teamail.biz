class Tagging < ActiveRecord::Base
  attr_accessible :tag_id, :taggable_id, :taggable_type

  belongs_to :taggable, :polymorphic => true
  belongs_to :tag
end
