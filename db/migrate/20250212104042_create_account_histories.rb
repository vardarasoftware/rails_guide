class CreateAccountHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :account_histories do |t|
      t.integer :credit_rating
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
