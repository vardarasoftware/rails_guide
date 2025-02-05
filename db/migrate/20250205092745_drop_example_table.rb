class DropExampleTable < ActiveRecord::Migration[8.0]
  def up
    if ActiveRecord::Base.connection.table_exists?('example_table')
      drop_table :example_table
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "This migration cannot be reverted because it destroys data."
  end
end
