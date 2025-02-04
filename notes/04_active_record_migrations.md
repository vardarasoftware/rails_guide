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

 




