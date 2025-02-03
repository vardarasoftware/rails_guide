class CreatePublications < ActiveRecord::Migration[8.0]
  def change
    create_table :publications do |t|
      t.string :title
      t.text :description
      t.references :publication_type, null: false, foreign_key: true
      t.references :publisher, polymorphic: true, null: false
      t.boolean :single_issue

      t.timestamps
    end
  end
end
