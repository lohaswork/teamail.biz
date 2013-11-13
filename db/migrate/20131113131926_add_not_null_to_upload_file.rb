class AddNotNullToUploadFile < ActiveRecord::Migration
  def change
    change_column :upload_files, :created_at, :datetime, :null => false
    change_column :upload_files, :updated_at, :datetime, :null => false
  end
end
