class AddActiveToAccount < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :active, :boolean
  end
end
