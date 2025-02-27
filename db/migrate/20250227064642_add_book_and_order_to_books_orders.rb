class AddBookAndOrderToBooksOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :books_orders, :book, null: false, foreign_key: true
    add_reference :books_orders, :order, null: false, foreign_key: true
  end
end
