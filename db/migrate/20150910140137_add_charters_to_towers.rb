class AddChartersToTowers < ActiveRecord::Migration
  def change
    add_column :towers, :charters, :integer
  end
end
