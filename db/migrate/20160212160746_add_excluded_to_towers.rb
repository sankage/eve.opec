class AddExcludedToTowers < ActiveRecord::Migration
  def change
    add_column :towers, :excluded, :boolean, default: false
  end
end
