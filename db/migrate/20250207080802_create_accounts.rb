class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.belongs_to :supplier, index: { unique: true }, foreign_key: true
      t.string :account_number

      t.timestamps
    end
  end
end
