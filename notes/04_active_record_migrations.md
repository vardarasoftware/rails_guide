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