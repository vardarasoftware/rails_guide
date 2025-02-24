class AddTitleToBookTwos < ActiveRecord::Migration[8.0]
  def change
    add_column :book_twos, :title, :string
  end
end
