class AddIndexToUserTopic < ActiveRecord::Migration
  def change
    add_index :user_topics, :user_id
    add_index :user_topics, :topic_id
  end
end
