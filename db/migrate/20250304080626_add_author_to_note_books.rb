class AddAuthorToNoteBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :note_books, :author, :string
  end
end
