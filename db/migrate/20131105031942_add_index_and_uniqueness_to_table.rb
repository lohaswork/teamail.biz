class AddIndexAndUniquenessToTable < ActiveRecord::Migration
  def change
    add_index :users, :email, unique: true
    add_index :early_adopters, :email, unique: true
  end
end
