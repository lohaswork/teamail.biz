class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :null => false
      t.string :email, :null => false
      t.string :password, :null => false
      t.string :remember_token, :null => false
      t.integer :organization_id
      t.integer :online_status, :null => false
      t.integer :active_status, :null => false
      t.integer :authority, :null => false

      t.timestamps
    end
  end
end
