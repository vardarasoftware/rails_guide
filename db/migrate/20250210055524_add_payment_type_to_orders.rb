class AddPaymentTypeToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :payment_type, :string
    add_column :orders, :card_number, :string
  end
end
