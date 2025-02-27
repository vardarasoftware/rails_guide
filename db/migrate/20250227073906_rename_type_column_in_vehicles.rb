class RenameTypeColumnInVehicles < ActiveRecord::Migration[8.0]
  def change
    rename_column :vehicles, :type, :vehicle_type
  end
end
