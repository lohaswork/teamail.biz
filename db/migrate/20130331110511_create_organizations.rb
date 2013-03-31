class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, :null => false
      t.string :email

      t.timestamps
    end
  end
end
