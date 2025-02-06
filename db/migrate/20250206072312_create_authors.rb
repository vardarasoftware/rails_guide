class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors, id: :string do |t|
      t.string :first_name
      t.string :last_name
      t.text :bio
      t.date :date_of_birth
      t.string :nationality
      t.string :email
      t.string :website
      t.integer :total_books
      t.timestamps
    end
  end
end
