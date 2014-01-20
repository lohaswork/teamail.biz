class AddFormalTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :formal_type, :integer, :default => 1
  end
end
