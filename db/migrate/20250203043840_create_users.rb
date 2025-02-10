class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, primary_key: "user_id" do |t|
      t.string :username
      t.string :email

      t.timestamps
    end
  end
end
