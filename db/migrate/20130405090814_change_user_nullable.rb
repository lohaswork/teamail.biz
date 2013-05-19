class ChangeUserNullable < ActiveRecord::Migration
  def up
    change_column :users, :name, :string, :null => true
    change_column :users, :password, :string, :null => true
    change_column :users, :remember_token, :string, :null => true
    change_column :users, :online_status, :integer, :null => true
    change_column :users, :active_status, :integer, :null => true
    change_column :users, :authority, :integer, :null => true
  end

  def down
    change_column :users, :name, :string, :null => false
    change_column :users, :password, :string, :null => false
    change_column :users, :remember_token, :string, :null => false
    change_column :users, :online_status, :integer, :null => false
    change_column :users, :active_status, :integer, :null => false
    change_column :users, :authority, :integer, :null => true
  end
end
