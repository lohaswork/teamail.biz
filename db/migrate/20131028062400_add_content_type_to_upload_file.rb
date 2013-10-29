class AddContentTypeToUploadFile < ActiveRecord::Migration
  def change
    add_column :upload_files, :content_type, :string
  end
end
