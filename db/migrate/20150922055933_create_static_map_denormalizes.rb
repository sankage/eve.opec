class CreateStaticMapDenormalizes < ActiveRecord::Migration
  def change
    create_table :static_map_denormalizes do |t|
      t.integer :item_id, limit: 8, unique: true
      t.integer :type_id
      t.integer :group_id
      t.integer :solar_system_id
      t.integer :constellation_id
      t.integer :region_id
      t.integer :orbit_id
      t.float :x
      t.float :y
      t.float :z
      t.float :radius
      t.string :item_name
      t.float :security
      t.integer :celestial_index
      t.integer :orbit_index
    end
  end
end
