class CreateUploadFiles < ActiveRecord::Migration
  def change
    create_table :upload_files do |t|
      t.string :name
      t.string :file
      t.integer :discussion_id

      t.timestamps
    end
  end
end
