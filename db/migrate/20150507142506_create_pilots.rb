class CreatePilots < ActiveRecord::Migration
  def change
    create_table :pilots do |t|
      t.integer :character_id
      t.string :name, unique: true

      t.timestamps null: false
    end
  end
end
