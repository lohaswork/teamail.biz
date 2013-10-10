class AddIndexToTables < ActiveRecord::Migration
  def change
    add_index :topics, :organization_id
    add_index :tags, :organization_id
    add_index :user_discussions, :user_id
    add_index :user_discussions, :discussion_id
    add_index :discussions, [:discussable_id, :discussable_type]
    add_index :organization_memberships, :organization_id
    add_index :organization_memberships, :user_id
    add_index :taggings, [:taggable_id, :taggable_type]
    add_index :taggings, :tag_id
  end
end
