# Active Record Migrations

## 1. Migration Overview

Migrations are a feature of Active Record that allows you to evolve your database schema over time. Rather than writing schema modifications in pure SQL, migrations allow you to use a Ruby Domain Specific Language (DSL) to describe changes to your tables.

### What is a Migration?
Each migration can be thought of as a "version" of the database. The schema starts with nothing, and each migration modifies it by adding or removing tables, columns, or indexes. Active Record ensures that your schema can be updated over time, moving from any point in its history to the latest version.

#### Example Migration:

```ruby
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
```

This migration creates a `products` table with columns for `name` and `description`. Additionally, `created_at` and `updated_at` columns are added via the `timestamps` macro. Active Record will also handle the primary key `id`.

#### db/schema.rb After Migration:

```ruby
ActiveRecord::Schema[8.0].define(version: 2024_05_02_100843) do
  enable_extension "plpgsql"

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
```

### Reversibility
Active Record supports migration reversibility, meaning migrations can be rolled back. For example, if the migration above is rolled back, it will remove the `products` table. This is key to maintaining database consistency.


## 2. Generating Migration Files

### 2.1 Creating a Standalone Migration
Migrations are stored in the `db/migrate` directory. They are timestamped to track the order in which they should be run. The timestamp format is `YYYYMMDDHHMMSS`, followed by an underscore and the name of the migration.

Example: `20240502100843_create_products.rb` should define `class CreateProducts`.

When generating a migration, the command will prepend the current timestamp to the file name:

```bash
$ bin/rails generate migration AddPartNumberToProducts
```

This will create a file:

```ruby
# db/migrate/20240502101659_add_part_number_to_products.rb
class AddPartNumberToProducts < ActiveRecord::Migration[8.0]
  def change
  end
end
```

### 2.2 Creating a New Table
To create a new table, use the following migration format:

```bash
$ bin/rails generate migration CreateProducts name:string part_number:string
```

This generates a migration that creates a `products` table with columns for `name` and `part_number`.

```ruby
class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :part_number

      t.timestamps
    end
  end
end
```

### 2.3 Adding Columns
To add new columns to an existing table, use the format `AddColumnToTable`. For example:

```bash
$ bin/rails generate migration AddPartNumberToProducts part_number:string
```

This generates the following migration:

```ruby
class AddPartNumberToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :part_number, :string
  end
end
```

You can also add an index to the new column:

```bash
$ bin/rails generate migration AddPartNumberToProducts part_number:string:index
```

This will generate the following migration:

```ruby
class AddPartNumberToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :part_number, :string
    add_index :products, :part_number
  end
end
```

### 2.4 Removing Columns
To remove columns, use the format `RemoveColumnFromTable`. For example:

```bash
$ bin/rails generate migration RemovePartNumberFromProducts part_number:string
```

This generates the migration:

```ruby
class RemovePartNumberFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :part_number, :string
  end
end
```

### 2.5 Creating Associations
To create foreign key references between tables, use the `references` column type. For example:

```bash
$ bin/rails generate migration AddUserRefToProducts user:references
```

This generates:

```ruby
class AddUserRefToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :user, null: false, foreign_key: true
  end
end
```

This adds a `user_id` column in `products` and creates a foreign key reference to the `users` table.

### 2.6 Other Generators that Create Migrations
You can use other generators like `model`, `resource`, or `scaffold` to create migrations when adding new models or resources.

For example, running:

```bash
$ bin/rails generate model Product name:string description:text
```

Generates the following migration:

```ruby
class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
```

### 2.7 Passing Modifiers
You can pass commonly used modifiers on the command line. For example:

```bash
$ bin/rails generate migration AddDetailsToProducts 'price:decimal{5,2}' supplier:references{polymorphic}
```

This generates the following migration:

```ruby
class AddDetailsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :price, :decimal, precision: 5, scale: 2
    add_reference :products, :supplier, polymorphic: true
  end
end
```

Additionally, you can add constraints like `NOT NULL`:

```bash
$ bin/rails generate migration AddEmailToUsers email:string!
```

This will generate:

```ruby
class AddEmailToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :email, :string, null: false
  end
end
```

# 3. Updating Migrations

Once you have created your migration file using one of the generators from the above section, you can update the generated migration file in the `db/migrate` folder to define further changes you want to make to your database schema.

## 3.1 Creating a Table

The `create_table` method is one of the most fundamental migration types, but most of the time, it will be generated for you from using a model, resource, or scaffold generator. A typical use would be:

```ruby
create_table :products do |t|
  t.string :name
end
```

- This method creates a `products` table with a column called `name`.

### 3.1.1 Associations

If you're creating a table for a model that has an association, you can use the `:references` type to create the appropriate column type. For example:

```ruby
create_table :products do |t|
  t.references :category
end
```
- This will create a `category_id` column. Alternatively, you can use `belongs_to` as an alias for `references`:

```ruby

create_table :products do |t|
  t.belongs_to :category
end
```

- You can also specify the column type and index creation using the `:polymorphic` option:

```ruby

create_table :taggings do |t|
  t.references :taggable, polymorphic: true
end
```

- This will create `taggable_id`, `taggable_type` columns and the appropriate indexes.

### 3.1.2 Primary Keys

By default, `create_table` will implicitly create a primary key called id for you. You can change the name of the column with the `:primary_key` option, like below:

```ruby

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, primary_key: "user_id" do |t|
      t.string :username
      t.string :email
      t.timestamps
    end
  end
end
```
- This will yield the following schema:

```sql

create_table "users", primary_key: "user_id", force: :cascade do |t|
  t.string "username"
  t.string "email"
  t.datetime "created_at", precision: 6, null: false
  t.datetime "updated_at", precision: 6, null: false
end
```
- You can also pass an array to `:primary_key` for a composite primary key. Read more about composite primary keys.

```ruby

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, primary_key: [:id, :name] do |t|
      t.string :name
      t.string :email
      t.timestamps
    end
  end
end
```

- If you don't want a primary key at all, you can pass the option `id: false`.

```ruby

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.string :username
      t.string :email
      t.timestamps
    end
  end
end
```

### 3.1.3 Database Options
If you need to pass database-specific options, you can place an SQL fragment in the `:options`` option. For example:

```ruby
create_table :products, options: "ENGINE=BLACKHOLE" do |t|
  t.string :name, null: false
end
```

- This will append `ENGINE=BLACKHOLE` to the SQL statement used to create the table.

- An index can be created on the columns created within the `create_table` block by passing `index: true` or an options hash to the `:index`option:

```ruby

create_table :users do |t|
  t.string :name, index: true
  t.string :email, index: { unique: true, name: "unique_emails" }
end
```

### 3.1.4 Comments

You can pass the `:comment`option with any description for the table that will be stored in the database itself and can be viewed with database administration tools, such as MySQL Workbench or PgAdmin III. Comments can help team members to better understand the data model and to generate documentation in applications with large databases. Currently, only the MySQL and PostgreSQL adapters support comments.

```ruby

class AddDetailsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :price, :decimal, precision: 8, scale: 2, comment: "The price of the product in USD"
    add_column :products, :stock_quantity, :integer, comment: "The current stock quantity of the product"
  end
end
```

## 3.2 Adding a Column

You can add a column to an existing table using the `add_column` method:

```ruby
add_column :users, :age, :integer
```

- This will add an `age` column of type `integer` to the `users` table.

###  3.2.1 Default Values
You can set a default value for the new column:

```ruby

add_column :users, :active, :boolean, default: true
```
- This will add a column `active` of type boolean and set the default value to `true`.

## 3.3 Removing Columns
To remove a column from a table, use the `remove_column` method:

```ruby
remove_column :users, :age

```
- This will remove the `age` column from the `users` table.

## 3.4 Renaming Columns
You can rename a column using the `rename_column` method:

```ruby

rename_column :users, :username, :user_name
```
This will rename the `username` column to `user_name` in the `users` table.

## 3.5 Changing Columns
You can change the properties of a column using the `change_column` method:

```ruby

change_column :users, :age, :string
```
- This will change the `age` column to a `string` type.

### 3.5.1 Altering Column Properties

You can also set properties like `null` or `default`:

```ruby

change_column :users, :email, :string, null: false, default: "unknown@example.com"
```
- This will alter the `email` column to make it non-nullable with a default value.

## 3.6 Removing a Table
To remove an entire table, you can use the `drop_table` method:

```ruby

drop_table :users
```
- This will delete the `users` table from the database.

## 3.7 Adding Indexes

You can add indexes to columns to improve query performance:

```ruby

add_index :users, :email, unique: true
```
- This will add a unique index on the `email` column of the `users` table.

## 3.8 Removing Indexes
To remove an index, you can use the `remove_index` method:

```ruby

remove_index :users, :email
```
This will remove the index on the `email` column from the `users` table.

## 3.9 Changing Table Names
You can rename a table using the `rename_table` method:

```ruby

rename_table :users, :members
```
- This will rename the `users` table to `members`.

## 3.10 Running Migrations
Once your migration is written, you can run it with the following command:

```bash

rails db:migrate
```
- This will apply all pending migrations to the database.

## 3.11 Rolling Back Migrations
If you want to undo a migration, use the `rollback` command:

```bash
rails db:rollback
```
- This will reverse the last migration.

## 3.12 Changing Database Schema Without Migrations
While migrations are the recommended way to modify the database schema, you can also directly change the schema using raw SQL. However, this approach is not recommended unless absolutely necessary.

```ruby
execute "ALTER TABLE products ADD COLUMN price DECIMAL(10, 2)"
```

## 4.1 Running Migration

### Run all the pending migration

```ruby
bin/rails db:migrate
```
- Runs `change` or `up` methods for all new migrations and updates `db/schema.rb` accordingly.

### Run migrations up to a specific version:

```bash

bin/rails db:migrate VERSION=20240428000000
```
Runs migrations `up` or `down` to the specified version.

## 4.2 Rolling Back Migrations

### Rollback the last migration:

```bash

bin/rails db:rollback
```
- Reverts the last migration using the `down` method or by reversing the `change` method.

### Rollback multiple migrations:

```bash

bin/rails db:rollback STEP=3
```

- Reverts the last 3 migrations.

### Redo (rollback and reapply) migrations:

```bash
bin/rails db:migrate:redo STEP=3
```
- Rolls back and reapplies the last 3 migrations.

## 4.3. Running Specific Migrations

### Run a specific migration:

```bash

bin/rails db:migrate:up VERSION=20240428000000
```
- Runs the `up` method (or change method) for the specified migration version.

### Rollback a specific migration:

```bash

bin/rails db:migrate:down VERSION=20240428000000
```
- Runs the `down` method for the specified migration version.

## 4.4. Database Setup & Reset

### Create database, load schema, and seed data:

```bash

bin/rails db:setup
```
- Sets up the database with schema and initial data.

### Prepare the database idempotently:

```bash
bin/rails db:prepare
```
- Ensures the database is properly set up without duplicating work.

### Reset database (drop and re-setup):

```bash
bin/rails db:reset
```
- Drops and recreates the database.

## 4.5. Running Migrations in Different Environments

### Run migrations in the test environment:

```bash

bin/rails db:migrate RAILS_ENV=test
```
- Runs migrations for the test database instead of development.

## 4.6. Managing Migration Transactions

### Disable automatic transaction handling in a migration:

```ruby

class ChangeEnum < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    execute "ALTER TYPE model_size ADD VALUE 'new_value'"
  end
end
```
- Useful when performing operations that cannot be wrapped in a transaction.

### 4.7. Controlling Migration Output

### Suppress output of specific migration actions:

```ruby

suppress_messages do
  create_table :products do |t|
    t.string :name
    t.text :description
    t.timestamps
  end
end
```
- Prevents unnecessary output during migration execution.

### Suppress all migration output:

```bash

bin/rails db:migrate VERBOSE=false
```
- Runs migrations silently.

## 4.8. Checking Migration History

### View applied migrations:

```sql

SELECT * FROM schema_migrations;
```
- Lists all executed migration versions stored in the database.

# 5. Schema and Schema Dump

## 5.1 Load Schema

- Instead of running all migrations, you can load the schema using

```bash
bin/rails db:schema:load
```

## 5.2 Types of Schema Dumps

### 5.2.1 Default `:ruby` Schema Format(db/schema.rb)

```ruby
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
```

### 5.2.2 Using the :sql Schema Format

- To enable :sql schema format, update `config/application.rb`

```ruby
config.active_record.schema_format = :sql
```

- This stores the schema in `SQL` format inside `db/structure.sql`.

- To work this, Instead of `db/schema.rb`, Rails runs database-specific dump commands:

#### PostgreSQL → `Uses pg_dump`
#### MySQL & MariaDB → `Uses SHOW CREATE TABLE`

- To load the schema from SQL format:

```sh
bin/rails db:schema:load
```

# 6. Active Record and Referential Integrity

- Active Record encourages keeping intelligence in models rather than databases.

- Database constraints like triggers are not favored but can be useful.

- Validations `(validates :foreign_key, uniqueness: true)` enforce integrity at the model level.

- The `:dependent` option ensures cascading deletions but does not guarantee referential integrity.

- Foreign key constraints and unique indexes are safer at the database level.

- Active Record does not directly support foreign key constraints, but SQL commands can be executed manually.

- Best practice: Complement Active Record with database-level constraints for data integrity.

# 7. Migrations and Seed Data

- Migrations modify the schema consistently and can be used to modify data.

- Rails migrations help manage schema changes in production without dropping the database.

```ruby Example Migration:

class AddInitialProducts < ActiveRecord::Migration[8.0]
  def up
    5.times do |i|
      Product.create(name: "Product ##{i}", description: "A product.")
    end
  end
  
  def down
    Product.delete_all
  end
end
```
- Rails `seeds` feature initializes data efficiently.

- Run `bin/rails db:seed` to populate initial data.

- Seed data should be idempotent (safe to run multiple times).

```ruby Example Seed Data:

["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
  MovieGenre.find_or_create_by!(name: genre_name)
end
```

# 8.Old Migrations

- `db/schema.rb` or `db/structure.sql` represents the current database state.

- Old migration files can be deleted but remain referenced in schema_migrations.

- Run bin/rails db:migrate:status to check migration statuses.

- Deleting and re-running engine migrations may create new files with new timestamps.