class AddEmailTitleToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :email_title, :string
  end
end
