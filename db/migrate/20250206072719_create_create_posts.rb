class CreateCreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :create_posts, id: :uuid do |t|
      t.references :author, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
