class AddIdToUserDiscussion < ActiveRecord::Migration
  def change
    add_column :user_discussions, :id, :primary_key
  end
end
