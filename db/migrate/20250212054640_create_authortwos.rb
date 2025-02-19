class CreateAuthortwos < ActiveRecord::Migration[8.0]
  def change
    create_table :authortwos do |t|
      t.string :name

      t.timestamps
    end
  end
end
