class CreateParagraphs < ActiveRecord::Migration[8.0]
  def change
    create_table :paragraphs do |t|
      t.text :content
      t.references :section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
