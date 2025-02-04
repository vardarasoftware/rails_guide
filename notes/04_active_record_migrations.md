##  Active Record Migrations **********

# 1 Migration Overview -----
    Migration in Rails are a way to manage changes in your database structure over time.
    This make our database updates easier to track and apply across the different environment.

    # How Migrations Work?
    --> Each migration is like a version of our database.
    --> Rails keep track of which migration have been run.
    --> Migration are reversible

    ** Example:-

        # db/migrate/20240502100843_create_products.rb
        class CreateProducts < ActiveRecord::Migration[8.0]
        def change
            create_table :products do |t|
            t.string :name
            t.text :description

            t.timestamps
            end
        end
        end

    -> Before running migration --> no "product" table exist
    -> After running migration --> a "product" table is created with columns 'name',
      'discription', 'created_at' and 'updated_at'.
    -> If we roll back the migration --> The "product" table is deleted.


    # why use migration?
    --> Database independent
    --> Version control
    --> Easy to undo 