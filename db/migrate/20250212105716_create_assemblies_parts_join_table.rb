class CreateAssembliesPartsJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_table :assemblies_parts, id: false do |t|
      t.belongs_to :assembly, foreign_key: true
      t.belongs_to :part, foreign_key: true
    end
  end
end
