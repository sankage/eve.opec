class CreateMoons < ActiveRecord::Migration
  def change
    create_table :moons do |t|
      t.integer :item_id
      t.string :name
      t.integer :planet
      t.integer :orbit
      t.belongs_to :system, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
