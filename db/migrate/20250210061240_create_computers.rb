class CreateComputers < ActiveRecord::Migration[8.0]
  def change
    create_table :computers do |t|
      t.boolean :desktop
      t.string :mouse
      t.string :trackpad
      t.string :market

      t.timestamps
    end
  end
end
