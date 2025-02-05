class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:products) 
      create_table :products, primary_key: [ :customer_id, :product_sku ] do |t|
        t.string :name
        t.string :part_number
        t.integer :customer_id
        t.string :product_sku
        t.text :description

        t.timestamps
      end
    end
  end
end
