class AddHideStatusToTag < ActiveRecord::Migration
  def change
    add_column :tags, :hide_status, :integer
  end
end
