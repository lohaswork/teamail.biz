class AddDiscussableTypeToDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :discussable_type, :string
  end
end
