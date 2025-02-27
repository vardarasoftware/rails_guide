class RemoveBookIdAndOrderIdFromBooksOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :books_orders, :book_id, :integer
    remove_column :books_orders, :order_id, :integer
  end
end
