class ChangeOrganizationTable < ActiveRecord::Migration
  def change
    remove_column :organizations, :email
    add_column :organizations, :plan, :integer
  end
end
