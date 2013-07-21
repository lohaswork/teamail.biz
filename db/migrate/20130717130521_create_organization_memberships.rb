class CreateOrganizationMemberships < ActiveRecord::Migration
  def change
    create_table :organization_memberships do |t|
      t.integer :organization_id
      t.integer :user_id
      t.integer :authority_type

      t.timestamps
    end
  end
end
