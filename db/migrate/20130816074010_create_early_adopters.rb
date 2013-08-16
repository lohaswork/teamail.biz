class CreateEarlyAdopters < ActiveRecord::Migration
  def change
    create_table :early_adopters do |t|
      t.string :email

      t.timestamps
    end
  end
end
