class AddEmailToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :email, :string, null: false
  end
end
