class ExampleMigration < ActiveRecord::Migration[8.0]
  def up
    create_table :distributors do |t|
      t.string :zipcode
    end

    # create a distributors view
    execute <<-SQL
      CREATE VIEW distributors_view AS
      SELECT id, zipcode
      FROM distributors;
    SQL

    add_column :users, :address, :string
  end

  def down
    remove_column :users, :address

    execute <<-SQL
      DROP VIEW distributors_view;
    SQL

    drop_table :distributors
  end
end
