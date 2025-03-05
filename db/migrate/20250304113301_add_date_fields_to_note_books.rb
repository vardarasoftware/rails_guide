class AddDateFieldsToNoteBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :note_books, :published_date, :date
    add_column :note_books, :reminder_time, :time
    add_column :note_books, :last_edited_at, :datetime
    add_column :note_books, :time_zone, :string
  end
end
