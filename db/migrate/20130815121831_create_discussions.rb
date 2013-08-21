class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.integer :topic_id
      t.integer :type
      t.text :content
      t.integer :user_from
      t.integer :user_to
      t.integer :user_cc
      t.integer :user_bcc

      t.timestamps
    end
  end
end
