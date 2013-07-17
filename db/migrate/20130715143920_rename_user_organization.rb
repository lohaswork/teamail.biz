class RenameUserOrganization < ActiveRecord::Migration
  def change
    rename_table :user_organization, :organizations_users
  end
end
