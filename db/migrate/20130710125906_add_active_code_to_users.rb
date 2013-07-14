class AddActiveCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active_code, :string
  end
end
