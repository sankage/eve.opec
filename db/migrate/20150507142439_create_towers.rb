class CreateTowers < ActiveRecord::Migration
  def change
    create_table :towers do |t|
      t.bigint :item_id, unique: true
      t.string :name
      t.integer :type_id
      t.integer :state
      t.integer :fuel_blocks
      t.integer :strontium
      t.belongs_to :moon, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
