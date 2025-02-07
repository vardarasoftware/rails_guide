class CreateCoffees < ActiveRecord::Migration[8.0]
  def change
    create_table :coffees do |t|
      t.string :size

      t.timestamps
    end
  end
end
