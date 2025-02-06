class AddDetailsToProducts < ActiveRecord::Migration[8.0]
  def change
    change_table :products do |t|
      unless column_exists?(:products, :description)
        add_column :products, :description, :string
      end
      rename_column :products, :price, :cost
      change_column :products, :cost, :decimal, precision: 8, scale: 2
    end
  end
end
