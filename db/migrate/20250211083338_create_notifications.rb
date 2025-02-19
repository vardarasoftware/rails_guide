class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :event
      t.references :usertwo, foreign_key: true

      t.timestamps
    end
  end
end
