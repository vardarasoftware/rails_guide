class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts, id: :uuid do |t|
      t.references :author, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
