class CreateUserTopics < ActiveRecord::Migration
  def change
    create_table :user_topics do |t|
      t.integer :user_id
      t.integer :topic_id
      t.integer :archive_status

      t.timestamps
    end
  end
end
