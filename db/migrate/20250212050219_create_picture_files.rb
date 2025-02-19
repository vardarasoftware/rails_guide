class CreatePictureFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :picture_files do |t|
      t.string :filename
      t.string :filepath

      t.timestamps
    end
  end
end
