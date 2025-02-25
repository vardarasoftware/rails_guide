class CreateBooksOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :books_orders do |t|
      t.references :book_three, null: false, foreign_key: true
      t.references :order_two, null: false, foreign_key: true

      t.timestamps
    end
  end
end
