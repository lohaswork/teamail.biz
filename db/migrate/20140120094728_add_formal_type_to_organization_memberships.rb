class AddFormalTypeToOrganizationMemberships < ActiveRecord::Migration
  def change
    add_column :organization_memberships, :formal_type, :integer, :default => 1
  end
end
