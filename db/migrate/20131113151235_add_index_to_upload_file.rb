class AddIndexToUploadFile < ActiveRecord::Migration
  def change
    add_index :upload_files, :discussion_id
  end
end
