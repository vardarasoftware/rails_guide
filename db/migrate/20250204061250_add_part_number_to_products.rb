class AddPartNumberToProducts < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:products, :part_number)
      add_column :products, :part_number, :string
      add_index :products, :part_number
    end
  end
end
