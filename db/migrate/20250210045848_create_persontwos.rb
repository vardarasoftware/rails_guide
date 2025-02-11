class CreatePersontwos < ActiveRecord::Migration[8.0]
  def change
    create_table :persontwos do |t|
      t.string :name
      t.string :email
      t.integer :age

      t.timestamps
    end
  end
end
