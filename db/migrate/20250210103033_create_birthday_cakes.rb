class CreateBirthdayCakes < ActiveRecord::Migration[8.0]
  def change
    create_table :birthday_cakes do |t|
      t.string :name
      t.string :flavor

      t.timestamps
    end
  end
end
