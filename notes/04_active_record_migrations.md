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
