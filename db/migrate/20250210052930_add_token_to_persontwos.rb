class AddTokenToPersontwos < ActiveRecord::Migration[8.0]
  def change
    add_column :persontwos, :token, :string
  end
end
