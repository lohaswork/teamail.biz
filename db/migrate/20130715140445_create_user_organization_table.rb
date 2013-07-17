class CreateUserOrganizationTable < ActiveRecord::Migration
  def change
    create_table :user_organization, :id => false do |t|
      t.column :user_id, :integer
      t.column :organization_id, :integer
    end
  end
end
