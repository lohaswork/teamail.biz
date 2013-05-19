class ChangeAuthorityName < ActiveRecord::Migration
  def change
    rename_column :users, :authority, :authority_type
  end
end
