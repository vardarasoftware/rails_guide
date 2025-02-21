class CreateOrderTwos < ActiveRecord::Migration[8.0]
  def change
    create_table :order_twos do |t|
      t.references :customer, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
