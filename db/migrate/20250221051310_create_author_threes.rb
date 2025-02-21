class CreateAuthorThrees < ActiveRecord::Migration[8.0]
  def change
    create_table :author_threes do |t|
      t.string :name

      t.timestamps
    end
  end
end
