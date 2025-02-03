class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :title
      t.string :author

      t.timestamps
    end
  end
end
