class CreateBookThrees < ActiveRecord::Migration[8.0]
  def change
    create_table :book_threes do |t|
      t.string :title
      t.integer :year_published
      t.decimal :price
      t.boolean :out_of_print
      t.references :author_three, null: false, foreign_key: true
      t.references :supplier_two, null: false, foreign_key: true

      t.timestamps
    end
  end
end
