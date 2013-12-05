class AddSizeToUploadFile < ActiveRecord::Migration
  def change
    add_column :upload_files, :size, :integer
  end
end
