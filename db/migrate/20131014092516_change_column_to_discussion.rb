class ChangeColumnToDiscussion < ActiveRecord::Migration
  def change
    change_column :discussions, :user_to, :string
    change_column :discussions, :user_cc, :string
    change_column :discussions, :user_bcc, :string
  end
end
