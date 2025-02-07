class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :bio
      t.string :password, null: false
      t.string :registration_number, null: false

      t.timestamps
    end
  end
end
