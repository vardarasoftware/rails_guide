class AddAuthorIdToBooks < ActiveRecord::Migration[8.0]
  def change
    add_reference :books, :author, foreign_key: true
  end
end
