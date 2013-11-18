class RemoveAuthorityTypeFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :authority_type, :integer
  end
end
