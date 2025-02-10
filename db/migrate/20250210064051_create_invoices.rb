class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.date :expiration_date
      t.decimal :discount
      t.decimal :total_value
      t.integer :customer_id

      t.timestamps
    end
  end
end
