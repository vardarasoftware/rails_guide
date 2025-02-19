class CreateAssemblies < ActiveRecord::Migration[8.0]
  def change
    create_table :assemblies do |t|
      t.string :name

      t.timestamps
    end
  end
end
