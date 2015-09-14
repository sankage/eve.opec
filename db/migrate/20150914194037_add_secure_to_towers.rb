class AddSecureToTowers < ActiveRecord::Migration
  def change
    add_column :towers, :secure, :boolean, default: false
  end
end
