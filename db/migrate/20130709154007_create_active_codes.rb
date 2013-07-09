class CreateActiveCodes < ActiveRecord::Migration
  def change
    create_table :active_codes do |t|
      t.integer :user_id
      t.text :code

      t.timestamps
    end
  end
end
