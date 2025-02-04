class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:products) 
      create_table :products do |t|
        t.string :name
        t.string :part_number

        t.timestamps
      end
    end
  end
end
