class AddIsAdminToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :is_admin, :boolean
    add_column :users, :password, :string
  end
end
