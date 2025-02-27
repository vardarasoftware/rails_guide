class FixBooksOrdersTable < ActiveRecord::Migration[8.0]
  def change
    rename_column :books_orders, :book, :book_id if column_exists?(:books_orders, :book)
    rename_column :books_orders, :order, :order_id if column_exists?(:books_orders, :order)
  end
end
