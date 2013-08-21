class CreateUserDiscussions < ActiveRecord::Migration
  def change
    create_table :user_discussions, :id => false do |t|
      t.integer :user_id
      t.integer :discussion_id
      t.integer :read_status

      t.timestamps
    end
  end
end
