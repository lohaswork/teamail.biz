class RemoveOrganiztionIdFromUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :organization_id
    end
  end
end
