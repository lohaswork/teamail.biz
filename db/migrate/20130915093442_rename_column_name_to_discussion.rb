class RenameColumnNameToDiscussion < ActiveRecord::Migration
  def up
    rename_column :discussions, :topic_id, :discussable_id
  end

  def down
    rename_column :discussions, :discussable_id, :topic_id
  end
end
