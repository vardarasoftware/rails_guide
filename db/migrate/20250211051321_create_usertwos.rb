class CreateUsertwos < ActiveRecord::Migration[8.0]
  def change
    create_table :usertwos do |t|
      t.string :name
      t.string :email
      t.string :location
      t.string :password_digest
      t.string :role

      t.timestamps
    end
  end
end
