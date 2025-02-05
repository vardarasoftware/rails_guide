class AddPriceToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :price, :decimal, precision: 5, scale: 2
  end
end
