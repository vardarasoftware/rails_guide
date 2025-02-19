class CreateBookTwos < ActiveRecord::Migration[8.0]
  def change
    create_table :book_twos do |t|
      t.references :authortwo, null: false, foreign_key: true
      t.datetime :published_at

      t.timestamps
    end
  end
end
