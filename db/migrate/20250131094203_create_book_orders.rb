class CreateBookOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :book_orders do |t|
      t.timestamps
    end
  end
end
