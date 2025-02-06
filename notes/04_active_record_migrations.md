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


# 2 Generating Migration Files ----
    # 2.1 Creating a Standalone Migration

        Each migration is stored in the 'db/migrate' folder and has a unique 'timestamp' in the file name to keep them organized.

        ** Example :-

        #--> "20240502100843_create_products.rb" <--#
        -> unique file name "20240502100843"
        -> This file defines class "CreateProducts"
        -> Rails use this timestamp to determine that which migration should be run in what order


        ## -> bin/rails generate migration AddPartNumberToProducts <-##

        This command is used to a new migration file that will modify the database
        --> "AddPartNumberToProducts"
            -> this is the name of the migration
            -> "AddPartNumber" is action (what we are doing)
            -> "ToProducts" is target table 
        
    
    # 2.2 Creating a New Table

        when we want to create a new table in our database, we use rails migration. 
        this will allow us to define the table structure.

        ## -> bin/rails generate migration CreateProducts name:string part_number:string <- ##

        This command is used to create a new table

        ***class CreateProducts < ActiveRecord::Migration[8.0]
            def change
                create_table :products do |t|
                t.string :name
                t.string :part_number

                t.timestamps
                end
            end
            end ***

    
    # 2.3 Adding Columns

        When we want to add new column to an existing table in our database, we use a migration in rails.

        ** Example 1: Adding a Single Column

        ##-> bin/rails generate migration AddPartNumberToProducts part_number:string <-

        this will generate migration file like this 
        class AddPartNumberToProducts < ActiveRecord::Migration[8.0]
            def change
                add_column :products, :part_number, :string
            end
        end

        "add_column :products, :part_number, :string" -> this will add a "part_number" column to the probuct table.


        ** Example 2: Adding a Column with an Index

        ##-> bin/rails generate migration AddPartNumberToProducts part_number:string:index <-

        if we want to add part_number and also create an index then this command generates:

        class AddPartNumberToProducts < ActiveRecord::Migration[8.0]
            def change
                add_column :products, :part_number, :string
                add_index :products, :part_number  # Creates an index for faster lookup
            end
        end

    
        ** Example 3: Adding Multiple Columns in One Migration

        ##-> bin/rails generate migration AddDetailsToProducts part_number:string price:decimal <-

        if we need to add more then one column then this command generate:

        class AddDetailsToProducts < ActiveRecord::Migration[8.0]
            def change
                add_column :products, :part_number, :string
                add_column :products, :price, :decimal
            end
        end

        this migration modifies the existing product table by adding two column
        -> part_number
        -> price


    # 2.4 Removing Columns

        If we want to remove a column from a table in your database, Rails provides a simple way to generate a migration file using this command:

        ##->  bin/rails generate migration RemovePartNumberFromProducts part_number:string <-

        -> 'RemovePartNumberFromProducts' --> this is the migration name.
        the naming convection helps rails to understand the purpose of the migration 

        class RemovePartNumberFromProducts < ActiveRecord::Migration[8.0]
            def change
                remove_column :products, :part_number, :string
            end
        end

    
    # 2.5 Creating Associations

        Active record associations allows us to define relationshp between different modules(tables).
        One way to define association is by using foregn keys.

        ##-> bin/rails generate migration AddUserRefToProducts user:references <-

        -> "user:references" --> this automatically add 'user_id' column in 'products' table
            and set a foregn key to link the 'users' table.
        
        class AddUserRefToProducts < ActiveRecord::Migration[8.0]
            def change
                add_reference :products, :user, null: false, foreign_key: true
            end
        end


        ##-> bin/rails generate migration AddUserRefToProducts user:belongs_to <-
        -> we can also use 'belongs_to' instead of 'referaences'.
        -> it will create same migration.


        #--> Creating a Join-Table 
            if we need a 'Many-to-Many' ralationship, rails provides us a spicail way to create join table.

        ##-> bin/rails generate migration CreateJoinTableUserProduct user product  <-

        class CreateJoinTableUserProduct < ActiveRecord::Migration[8.0]
            def change
                create_join_table :users, :products do |t|
                # t.index [:user_id, :product_id]
                # t.index [:product_id, :user_id]
                end
            end
        end

        -> create_join_table :users, :products --> Creates a new table called products_users.

    
    # 2.6 Other Generators that Create Migrations

        When we create a new model in Rails, it also generates a migration file that defines the database table for that model. 
        This migration will include the necessary instructions to create the table and add columns.

        ##-> bin/rails generate model Product name:string description:text

        class CreateProducts < ActiveRecord::Migration[8.0]
            def change
                create_table :products do |t|
                t.string :name
                t.text :description

                t.timestamps
                end
            end
        end

    
    # 2.7 Passing Modifiers

        Rails allows us to customize database columns directly from the migration command, saving time and reducing manual edits. 
        we can use modifiers inside {} to define specific constraints.

        ##-> bin/rails generate migration AddDetailsToProducts 'price:decimal{5,2}' supplier:references{polymorphic}

        with this command:
        -> Adds a 'price' column  
        -> Adds a 'supplier' reference

        class AddDetailsToProducts < ActiveRecord::Migration[8.0]
            def change
                add_column :products, :price, :decimal, precision: 5, scale: 2
                add_reference :products, :supplier, polymorphic: true
            end
        end

        #--> Adding a NOT NULL constrains using "!"

        ##-> bin/rails generate migration AddEmailToUsers email:string!

        -> Adds an "email" column
        -> Adds "null:false" to ensure the email must be present.

        class AddEmailToUsers < ActiveRecord::Migration[8.0]
            def change
                add_column :users, :email, :string, null: false
            end
        end


# 3 Updating Migrations ----

    After generating migration file, we can modify it before running "rails/db:migrate".
    this allow us to make additional changes 
    -> Adding more column
    -> Changing column types
    -> Setting default values
    -> Adding constraints

    # 3.1 Creating a Table
        The 'create_table' method is used to define new table in database

        create_table :products do |t|
            t.string :name
        end

        -> This creats a 'product' table with a column 'name' 
    
    ## 3.1.1 Associations
        if our table needs to reference another table, we can use 'reference'

        --> create_table :products do |t|
                t.references :category
            end

        this create a 'category_id' column in 'products' table, linking it the 'categories' table

        -> we can use 'belongs_to' insted of 'reference', it will work same as reference.


        --> Polimorphic associations

        create_table :taggings do |t|
            t.references :taggable, polymorphic: true
        end

        This creates 'taggable_id' and 'taggable_type'.
        It allows a single table to reference multipal modules like 'posts', 'images' etc

    ## 3.1.2 Primary Keys
        By default, 'create_table' creates an 'id' column as a primary key.
        but we can coustmize the primary key name

        class CreateUsers < ActiveRecord::Migration[8.0]
            def change
                create_table :users, primary_key: "user_id" do |t|
                t.string :username
                t.string :email
                t.timestamps
                end
            end
        end

        -> we can also pass multipal column as primary key 

        class CreateUsers < ActiveRecord::Migration[8.0]
            def change
                create_table :users, primary_key: [:id, :name] do |t|
                t.string :name
                t.string :email
                t.timestamps
                end
            end
        end

        -> If we don't want primary key at all then we can pass the option 'id:false'

        class CreateUsers < ActiveRecord::Migration[8.0]
            def change
                create_table :users, id: false do |t|
                t.string :username
                t.string :email
                t.timestamps
                end
            end
        end

        --> this will not create an 'id' column 

    ## 3.1.3 Database Options
        If we need to pass database-specific options that we can place an SQL fragment in the ':options' option.

        create_table :products, options: "ENGINE=BLACKHOLE" do |t|
            t.string :name, null: false
        end

        -> This creates a products table with ENGINE=BLACKHOLE, a special MySQL engine.


    ## 3.1.4 Comments
        Comments help document the database schema. Supported in MySQL and PostgreSQL.

    //->class AddDetailsToProducts < ActiveRecord::Migration[8.0]
            def change
                add_column :products, :price, :decimal, precision: 8, scale: 2, comment: "The price of the product in USD"
                add_column :products, :stock_quantity, :integer, comment: "The current stock quantity of the product"
            end
        end

        --> price: Decimal with 8 digits in total, 2 after the decimal (e.g., 99999.99).
        --> stock_quantity: Integer with a comment explaining it.

    
    # 3.2 Creating a Join Table

        The 'create_join_table' method is used to create HABTM(Has And Belongs To Many) Join tables.

        //--># create_join_table :products, :categories

        -> this creates a join table named 'catagoris_products'
        -> it include two column 
            1. category_id
            2. product_id
        

        # Allowing NULL Values
        if we want the column to accept NULL value, we can override this with 'column_options'

        //#--> create_join_table :products, :categories, column_options: { null: true }

        --> now the 'category_id' and 'product_id' can be NULL.


        # Customize the table name
        Table name is automatically determine using lexical order of the argument

        //#--> create_join_table :products, :categories
        This creates 'categories_products' table name

        If we want to customize the table name we can do this:
        //#--> create_join_table :products, :categories, table_name: :categorizations
        after running this the table name will be 'categorizations' instead of 'categories_product'.



    # 3.3 Changing Tables

        The 'change_table' method is used when we want to modify the existing table instend creating new table.
        it allow us to perform multiple changes within in a single migration.

    //->change_table :products do |t|
            t.remove :description, :name
            t.string :part_number
            t.index :part_number
            t.rename :upccode, :upc_code
        end

        after running the migration:
        -> 'name' and 'description' columns are remove
        -> a new 'part_number' column added
        -> An index is created on 'part_number'
        -> The 'upccode' renamed as 'upc_code'

    
    # 3.4 Changing Columns

        When working on database in rails, we might need to modify existing columns instead of the adding or removing them.

    --> *changing the data type of column*

        //--># change_column :products, :part_number, :text #<--
        --> Changes the 'part_number' column in 'product' table from existing data type to 'text'.
        --> 'change_column' is not reversible, means Rails cannot automatically revert this change
            while rolling back the migration.
        --> we must menually definehow to undo it.

    --> *Changing Default Values*
        
        //--># change_column_default :products, :approved, from: true, to: false #<-
        --> change the default value of the approved column
            -> Before: the default value 'true'
            -> after: the default value 'false'
        
    --> *Changing NULL Constraints*
        
        //--># change_column_null :products, :name, false #<--

        --> Modifies the 'name' column in the 'products' table to NOT NULL.
        

    # 3.5 Column Modifiers

        Column Modifiers are the options we can use when creating or changing column in database table
        -> 'comment' -- add a note about the column
        -> 'collation -- sets the sorting and comparison rules for text column
        -> 'default' -- assign the default value to the column. Use 'nil' for NULL values.
        -> 'limit' -- define the maximam length of the string or maximum size of numbers.
        -> 'null' -- specify whether the column can have NULL value or not.
        -> 'precision' -- determine the total number of digit for numeric/decimal/datetime value.
        -> 'scale' -- set how many digits appear after the decimal for decimal/numeric value.

        --> 'indexes' can not be added using 'add_column' or 'change_column'. we must use 'add_index' separately.
    

    # 3.6 References

        The 'add_reference' method is used in database migration for creating a column  that likns one table to another, forming an association between them.

        //#-->  add_reference :users, :role

        -> this adds a 'role_id' column in the 'user' table.
        -> 'role_id' refes to the 'id' column in 'roles' table.
        -> By default it also creates an index for faster lookups.
        -> If we don't want the index, we can use 'index:false'

        //#--> add_belongs_to :taggings, :taggable, polymorphic: true

        -> 'add_belongs_to' does the same thing as 'add_reference'
        -> the 'polymorphic: true' create the two columns:
            -> 'taggable_id'
            -> 'taggable_type'
        -> This allows one column to be linked to multipal tables to making it polymorphic.


        ## adding a foreign key

        //#-->  add_reference :users, :role, foreign_key: true

        -> The 'foreign_key: true' option enforce the relationship at the database level.
        -> It ensure that 'role_id' must always refer to a valid record in the 'roles' table.


        ## Removing a Reference

        //#--> remove_reference :products, :user, foreign_key: true, index: false

        -> This removes the 'user_id' column from the 'product' table
        -> 'foreign_key' removes the foreign key constraion.
        -> 'index: false' removes the index on 'user_id'.

    
    # 3.7 Foreign Keys

        A 'foreign key' is a database constaint that ensures data integrity by enforcing relationship between talbes.

        # adding a foreign key

        //--> add_foreign_key :articles, :authors
    
        -> this ensure that every 'articals.authors_id' must have the matching 'id' in 'authors' table.
        
        # Foreign Keys with references

        //--> add_reference :articles, :author, foreign_key: true
        
        -> Adds an 'author_id' column in 'articals' table.
        -> automatically sets foreign key constrain on 'authoe_id'

        # Custom Foreign Key Column Name

        //--> add_foreign_key :articles, :authors, column: :reviewer, primary_key: :email

        -> Here, 'articles.reviewer' (not author_id) must match 'authors.email'.
        -> Useful when linking tables based on unique non-ID fields like emails or usernames.

        # Removing a Foreign Key

        //--> remove_foreign_key :accounts, :branches

        -> This removes the foreign key linking 'accounts.branch_id' to 'branches.id'

        //--> remove_foreign_key :accounts, column: :owner_id

        -> This removes the foreign key constraint from 'accounts.owner_id'.


    # 3.8 Composite Primary Keys

        we can create a table with a composite primary key by passing the ':primary_key'option to 'create_table' with an array value.

    //->class CreateProducts < ActiveRecord::Migration[8.0]
            def change
                create_table :products, primary_key: [:customer_id, :product_sku] do |t|
                t.integer :customer_id
                t.string :product_sku
                t.text :description
                end
            end
        end

        -> instead of using single 'id' column as a primary key, it defines two column as 
           the primary key
           -> customer_id
           -> product_sku
        -> no need for separate 'id' column

        -> A composite primary key means multiple columns together uniquely identify each row.
        -> It’s useful for legacy databases, many-to-many relationships, and sharding.


    # 3.9 Execute SQL

        The 'execute' method in Rails allows us to run raw SQL commands in migration when active record built-in methods are not enough.

    //->class UpdateProductPrices < ActiveRecord::Migration[8.0]
            def up
                execute "UPDATE products SET price = 'free'"
            end

            def down
                execute "UPDATE products SET price = 'original_price' WHERE price = 'free';"
            end
        end

        -> 'up' method runs when applying, setting all 'products.price' values to 'free'
        -> 'down' method runs when rolling back, restoring price to the 'original_price'

    
    # 3.10 Using the change Method

        The 'change' method is the most comman way to write migration in rails because it allows automatically rollback.

        -> add_check_constraint -- Adds a constraint to ensure column values meet certain conditions
        -> add_column --Adds a new column in existing table

        -> add_foreign_key -- Adds a foreign key constrain to enforce data integrity

        -> add_index -- Adds an index to a column for faster queries

        -> add_reference -- Adds a reference (foreign key) to another table

        -> add_timestamps -- Adds created_at and updated_at timestamps

        -> change_column_comment (must supply :from and :to options) -- Adds or changes a comment on a column

        -> change_column_default (must supply :from and :to options) -- changes the default value of a column

        -> change_column_null

        -> change_table_comment (must supply :from and :to options) -- Adds or updates a comment for a table

        -> create_join_table -- Creates a join table for many-to-many relationships

        -> create_table -- Creates a new table. Rollback Automatically drops the table

        -> disable_extension -- Disables an extension

        -> drop_join_table -- Drops a join table

        -> drop_table (must supply table creation options and block) -- Drops a table

        -> enable_extension -- Enables a database extension

        -> remove_check_constraint (must supply original constraint expression) -- Removes a 
           previously added constraint.

        -> remove_column (must supply original type and column options) -- Removes a column from a
           table

        -> remove_columns (must supply original type and column options)

        -> remove_foreign_key (must supply other table and original options) -- Remove foreign key

        -> remove_index (must supply columns and original options) -- Remove index from a column

        -> remove_reference (must supply original options) -- Removes a reference

        -> remove_timestamps (must supply original options) -- Removes created_at and updated_at
           timestamps

        -> rename_column -- Renames a column

        -> rename_index -- Renames an index

        -> rename_table -- Renames a table

    
    # 3.11 Using reversible

        ->Migration in rails help modify the database schema, and typically, the 'change' mothod
          allows automatically reversal.
        ->There are cases where active record cannot automatically revert a migration.
        ->For that cases, we use 'reversible', 'up' and 'down' method to define how to apply the
          undo changes.

        //-->
        class ChangeProductsPrice < ActiveRecord::Migration[8.0]
            def change
                reversible do |direction|
                    change_table :products do |t|
                        direction.up   { t.change :price, :string }
                        direction.down { t.change :price, :integer }
                    end
                end
            end
        end
        <--//

        -> When running rails 'db:migrate', it changes 'price' column type to 'string'.
        -> When running rails 'db:rollback', it reverts 'price' column back to 'integer'.

        # Why use reversible?
        --> Active record does not revert automatically column type changes, so we must specify both up and down method.

        
        ## Alternatively, you can use up and down instead of change:

        //-->
        class ChangeProductsPrice < ActiveRecord::Migration[8.0]
            def up
                change_table :products do |t|
                    t.change :price, :string
                end
            end

            def down
                change_table :products do |t|
                    t.change :price, :integer
                end
            end
        end
        <--//

        -> Instead of 'change', we can define separate up and down methods for more manual control
        -> 'up' defines what happens when applying the migration
        -> 'down' defines how to reverse the migration


        ## Using reversible for Raw SQL Queries

        //-->
        class ExampleMigration < ActiveRecord::Migration[8.0]
            def change
                create_table :distributors do |t|
                    t.string :zipcode
                end

                reversible do |direction|
                    direction.up do
                        # create a distributors view
                        execute <<-SQL
                            CREATE VIEW distributors_view AS
                            SELECT id, zipcode
                            FROM distributors;
                        SQL
                    end
                    direction.down do
                        execute <<-SQL
                            DROP VIEW distributors_view;
                        SQL
                    end
                end

                add_column :users, :address, :string
            end
        end
        <--//

        -> The reversible method is useful when using raw SQL queries that Active Record cannot track.
        -> It ensures that when a migration is rolled back, the SQL commands are reversed in the correct order.


    # 3.12 Using the up/down Methods

        ->The up method is used to apply changes to the database, while the down method is used to
          undo those changes. 
        ->The goal is that if you apply up and then down, the database should return to its 
          original state.

        //-->
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
        <--//

        -->> Up method
        - Creates distributors table with a zipcode column
        - Creates a SQL View (distributors_view) using raw SQL
        - Adds a new column address to users table

        -->> down method
        - Drops distributors table
        - Removes (DROP) the SQL View
        - Removes address column from users table

    

    # 3.13 Throwing an error to prevent reverts

        Sometimes, a migration performs an action that permanently destroys data, making it impossible to revert. For example:

        -> Dropping a table (drop_table :example_table)
        -> Removing a column (remove_column :users, :email)
        -> Deleting records (delete_all or truncate)

        //-->
        class IrreversibleMigrationExample < ActiveRecord::Migration[8.0]
            def up
                drop_table :example_table
            end

            def down
                raise ActiveRecord::IrreversibleMigration, "This migration cannot be reverted because it destroys data."
            end
        end
        <--//

        -> In 'up' method we drop the 'example_table' table when we do 'db/migrate'
        -> In 'dwon' method we tring to rollback but it give us "This migration cannot be reverted because it destroys data."

    
    # 3.14 Reverting Previous Migrations

        The revert method in Rails provides a way to easily undo or "rollback" changes made by a previous migration
        The revert method allows us to undo actions from a previous migration, including:
        
        -> Rolling back an entire migration: we can call revert with a migration name to undo all
           of its changes.
        -> Rolling back part of a migration: we can also pass a block to revert to manually define
           what should be rolled back.
        
        //-->
        require_relative "20121212123456_example_migration"

        class FixupExampleMigration < ActiveRecord::Migration[8.0]
            def change
                revert ExampleMigration

                create_table(:apples) do |t|
                    t.string :variety
                end
            end
        end
        <--//

        -> The migration class 'FixupExampleMigration' calls revert 'ExampleMigration', which will
           undo everything that was done in 'ExampleMigration'.
        -> After the 'reversal', a new table apples is created with a 'variety' column.

        ## Reverting Part of a Migration

        //-->
        class DontUseDistributorsViewMigration < ActiveRecord::Migration[8.0]
            def change
                revert do
                    # copy-pasted code from ExampleMigration
                    create_table :distributors do |t|
                        t.string :zipcode
                    end

                    reversible do |direction|
                        direction.up do
                            # create a distributors view
                            execute <<-SQL
                                CREATE VIEW distributors_view AS
                                SELECT id, zipcode
                                FROM distributors;
                            SQL
                        end
                        direction.down do
                            execute <<-SQL
                                DROP VIEW distributors_view;
                            SQL
                        end
                    end

                    # The rest of the migration was ok
                end
            end
        end
        <--//

        -> The revert method is passed a block where the actions that were part of the previous
           migration are specified.
        -> Inside the block, the create_table :distributors and the reversible block are redefined.
        -> When you run rails db:migrate, this migration will undo the create_table :distributors
           and the creation of the distributors_view. Essentially, it undoes those parts of the previous migration.

        # Advantages of 'revert'
        -> Simplicity
        -> Avoid repetition
        -> Safety

        

# 4 Running Migrations -------
    
    #-> What is bin/rails 'db:migrate'?
        -> This command runs all pending migrations in your Rails application
        -> Migrations are applied in order, based on the timestamp in the migration filename
    
    #-> What happens when you run 'db:migrate'?
        -> Executes the 'change' or 'up' method in migration files that have not been run yet
        -> Updates the database schema accordingly
        -> Runs 'db:schema:dump' automatically, which updates 'db/schema.rb' to reflect the latest
           database structure
        
    //--> 
    bin/rails db:migrate VERSION=20240428000000 
    <--//

    -> here, '20240428000000' is represent the recent timestamp in our migration file

    ## 4.1 Rolling Back

        -> Sometimes, we need to undo a migration—maybe there was a mistake or we want to modify
           something. 
        -> Instead of manually finding the migration version, Rails provides easy rollback 
           commands.
        
        //->
        bin/rails db:rollback
        <-//
        
        -> To Undo the last migration we simply run this command
        -> Rails finds the last migration that was applied
        -> It 'revert' it using 'down' method
        -> The schema was update accordingly

        # Rolling back multipal migration

        //->
        bin/rails db:rollback STEP=3
        <-//

        -> The last 3 migrations will be reversed in order
        -> Rails executes the down method for each migration.

        # Rolling Back Multiple Migrations and Reapplying

        //->
        bin/rails db:migrate:redo STEP=3
        <-//

        -> This will undo and reapply the last 3 migrations

    ## 4.1.1 Transactions

        -> When running migrations, Rails tries to wrap each migration in a database transaction. -> This ensures database consistency by preventing partial migrations from being applied
           if an error occurs.
        -> DDL --> Data Definition Language

        //-->
        class AddEmailToUsers < ActiveRecord::Migration[8.0]
            def change
                add_column :users, :email, :string
            end
        end
        <--//

        -> If add_column :users, :email, :string succeeds, Migration is applied.
        -> If it fails halfway, Rails rolls back everything, leaving the database unchanged.

        # When to Disable DDL Transactions

        //->
        class ChangeEnum < ActiveRecord::Migration[8.0]
            disable_ddl_transaction!  # ❌ Disables the automatic transaction

            def up
                execute "ALTER TYPE model_size ADD VALUE 'new_value'"
            end
        end
        <-//

        -> By calling 'disable_ddl_transaction!', Rails will not wrap this migration in a
           transaction and let it run
    

    # 4.2 Setting Up the Database

        The "bin/rails db:setup" command will create the database, load the schema, and initialize it with the seed data.

    
    # 4.3 Preparing the Database

        -> The 'bin/rails db:prepare' command is used to get your database ready for use
        -> If the database doesn't exist yet, it will create it, just like 'bin/rails db:setup'
        -> If the database exists but the tables aren’t created, it will set up the tables, run 
           any new migrations, update the schema, and load the seed data.
        -> If everything is already set up, it won't do anything.
        -> Once the database and tables are set up, it won’t reload the seed data, even if the
           seed file has changed
        -> If we need to reload the seed data, need to run 'bin/rails db:seed' manually.

    # 4.4 Resetting the Database

        -> The 'bin/rails db:reset' command will drop the database and set it up again. 
        -> This is functionally equivalent to 'bin/rails db:drop db:setup'.

    # 4.5 Running Specific Migrations

        -> The 'bin/rails db:migrate:up' and 'bin/rails db:migrate:down' commands allow you to run
           a specific migration manually
        -> we can specify the version of the migration we want to apply or undo 

        //->
        bin/rails db:migrate:up VERSION=20240428000000
        <-//

        -> This will execute the "up" method of the migration with the version 20240428000000,
           applying the changes defined in that migration.
        -> Checking for Existing Migration: Rails will check if the migration exists and if it has
            already been applied. If it has, it won’t do anything.
        -> Non-Existing Migration: If you try to run a migration version that doesn't exist, like
           'bin/rails db:migrate VERSION=20240428000000' 
        -> Rails will give you an error saying it can't find the migration with that version 
           number
        
    
    # 4.6 Running Migrations in Different Environments

        -> By default, when we run 'bin/rails db:migrate', it applies migrations to the development
           environment.
        -> If we want to run the migrations for a different environment, like 'test', we can 
           specify that using the 'RAILS_ENV' variable.

        //->
        $ bin/rails db:migrate RAILS_ENV=test
        <-//

    # 4.7 Changing the Output of Running Migrations

        -> When we run migrations, Rails usually shows messages telling we what it's doing and how 
           long each step takes, For example:

            ==  CreateProducts: migrating =================================================
            -- create_table(:products)
            -> 0.0028s
            ==  CreateProducts: migrated (0.0028s) ========================================
        
        -> However, you can control this output in different ways using methods in your migration:
            -> suppress_messages: Hides all output inside the block.
            -> say: Displays a custom message. You can also choose if it should be indented.
            -> say_with_time: Shows a message along with how long it took to run that part of the
               migration.
        
        For example:
        //-->
        class CreateProducts < ActiveRecord::Migration[8.0]
            def change
                suppress_messages do
                    create_table :products do |t|
                        t.string :name
                        t.text :description
                        t.timestamps
                    end
                end

                say "Created a table"

                suppress_messages { add_index :products, :name }
                say "and an index!", true

                say_with_time "Waiting for a while" do
                    sleep 10
                    250
                end
            end
        end
        <--//

        This will generate the following output:

        ==  CreateProducts: migrating =================================================
        -- Created a table
        -> and an index!
        -- Waiting for a while
        -> 10.0013s
        -> 250 rows
        ==  CreateProducts: migrated (10.0054s) =======================================

        
        --> If we want no output at all, we can run bin/rails db:migrate VERBOSE=false to 
            suppress everything.
        
    # 4.8 Rails Migration Version Control
        
        -> Rails keeps track of which migrations have been run using a special table called
           schema_migrations. 
        -> This table is automatically created in our database when you set up Rails.
        
        -> When we run a migration, Rails extracts the version number from the migration file
           name and inserts it into the schema_migrations table.
        
        # For example 
        -> If we have a migration file '20240428000000_create_users.rb', Rails will:
            ->Extract the version number '20240428000000' from the file name.
            ->After the migration is successfully applied, it will insert this version number
              into the schema_migrations table.
        
        //->
        rails dbconsole
        <-//
        //->
        SELECT * FROM schema_migrations;
        <-//

        -> This will show us a list of version numbers for all the migrations that have been 
           successfully applied to our database.
        


# 5 Changing Existing Migrations ----

    -> When we make a mistake in a migration and try to fix it, we can't just edit the migration
       and run it again, because Rails thinks the migration has already been applied. 
    -> If we try to run 'bin/rails db:migrate' again, Rails will do nothing.

    -> Here's what we should do:
        > Rollback the migration
        > Edit the migration
        > Re-run the migration
    
    -> Don't edit migrations that have already been committed to source control, especially if 
       they've been run in production. 
    -> This can create problems for our team because it would affect everyone else's setup.
    -> Instead, create a new migration to apply the changes you want.

    -> If the migration hasn't been committed to source control or hasn’t been used on other
       machines (like in development), we can safely edit it.
    -> The revert method can also help if we want to undo a part of a migration in a new 
       migration, but it's better to create a new migration for changes whenever possible.


# 6 Schema Dumping and You ----
    
    # 6.1 What are Schema Files for?

        -> Rails automatically generates a file called 'db/schema.rb', which is a snapshot of our
           database structure at the latest migration.
        -> When setting up a new database, instead of running all migrations one by one, it's
           faster and safer to directly load the 'schema' 
        
        //-->
        bin/rails db:schema:load
        <--//

        -> This quickly sets up the database according to the latest schema file 
        -> Avoiding potential issues from outdated migrations


    # 6.2 Types of Schema Dumps
        
        -> In Rails, the way your database schema is saved is controlled by the 
           'config.active_record.schema_format' setting in 'config/application.rb'.
        -> There are two formats you can choose from:
            > Using the default :ruby schema
            > Using the :sql schema dumper
        
        #> Using the default :ruby schema
            -> This is the default format in Rails.
            -> The database structure is written in a Ruby-based file 'db/schema.rb'.
            -> It looks similar to a migration file, using commands like 'create_table' and 
               'add_index'.
            
            //->
            ActiveRecord::Schema[8.0].define(version: 2008_09_06_171750) do
                create_table "authors", force: true do |t|
                    t.string   "name"
                    t.datetime "created_at"
                    t.datetime "updated_at"
                end

                create_table "products", force: true do |t|
                    t.string   "name"
                    t.text     "description"
                    t.datetime "created_at"
                    t.datetime "updated_at"
                    t.string   "part_number"
                end
            end
            <-//

            -> This format is simple, readable, and easy to use, but it cannot store advanced
               database features like triggers, sequences, or stored procedures.
        

        #> Using the :sql schema dumper
            -> If our database uses advanced features not supported in Ruby migrations, we
               should use ':sql' format instead.
            -> When set to ':sql', Rails dumps the database structure as a raw SQL file 
               'db/structure.sql'
            
            # How to load schema for SQL
            //->
            bin/rails db:structure:load
            <-//

            -> Use ':sql' if our database has custom features that 'db/schema.rb' cannot
               represent.

    # 6.3 Schema Dumps and Source Control

        -> Always add your schema file 'db/schema.rb'to version control (Git, etc.) because it
           helps in setting up new databases easily.
        -> 'Merge conflicts' can happen in the schema file if multiple branches modify the 
            database structure.
        
        //-->
        bin/rails db:migrate
        <--//

        -> This will reapply migrations and regenerate the schema file correctly



