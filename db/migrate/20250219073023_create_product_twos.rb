class CreateProductTwos < ActiveRecord::Migration[8.0]
  def change
    create_table :product_twos do |t|
      t.string :name

      t.timestamps
    end
  end
end
