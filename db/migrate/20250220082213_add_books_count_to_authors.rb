class AddBooksCountToAuthors < ActiveRecord::Migration[8.0]
  def change
    add_column :authors, :books_count, :integer, default: 0, null: false
  end
end
