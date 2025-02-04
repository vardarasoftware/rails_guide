class AddPartNumberToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :part_number, :string
    add_index :products, :part_number
  end
end
