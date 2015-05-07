class CreateTowerStakes < ActiveRecord::Migration
  def change
    create_table :tower_stakes do |t|
      t.belongs_to :pilot, index: true, foreign_key: true
      t.belongs_to :tower, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
