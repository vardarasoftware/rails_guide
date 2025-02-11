class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.bigint "library_id", null: false

      t.timestamps
    end
  end
end
