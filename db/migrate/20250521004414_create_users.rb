class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :full_name
      t.integer :role, default: 0, null: false

      t.timestamps
    end
  end
end
