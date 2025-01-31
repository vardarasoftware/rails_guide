# 1. Active Record
Active Record is part of the **M (Model)** in the **MVC (Model-View-Controller)** architecture. It is responsible for representing data and business logic. Active Record allows us to create and use Ruby objects whose attributes are stored persistently in a database.

### Difference Between Active Record and Active Model
- **Active Record**: Used for modeling data with Ruby objects that require database storage.
- **Active Model**: Used for modeling data with Ruby objects that do not require database storage.
- Both Active Record and Active Model are part of the Model layer in MVC.
- Plain Ruby objects can also be used as models in Rails without Active Record.

### Active Record as a Pattern
- "Active Record" is also a **software architecture pattern**.
- Rails’ Active Record is an **implementation** of this pattern.
- It is a type of **Object Relational Mapping (ORM)** system.

## 1.1 The Active Record Pattern
> Martin Fowler describes the Active Record pattern in *Patterns of Enterprise Application Architecture* as:
>
> *"An object that wraps a row in a database table, encapsulates the database access, and adds domain logic to that data."*

- Active Record objects contain both **data** and **behavior**.
- The structure of Active Record classes closely matches database tables.
- This makes it easy to read and write data to the database using Ruby objects.

## 1.2 Object Relational Mapping (ORM)
- **ORM** connects objects in a programming language (like Ruby) to relational database tables.
- In Rails, **Active Record** serves as the ORM system.
- ORMs minimize the need to write raw SQL queries by mapping database tables to Ruby objects.
- Using an ORM, we can:
  - Store object attributes in the database.
  - Retrieve data without direct SQL queries.
  - Define relationships between objects easily.


## 1.3 Active Record as an ORM Framework
Active Record provides the following capabilities using Ruby objects:

- **Represent models and their data**.
- **Define associations** between models (e.g., `belongs_to`, `has_many`).
- **Implement inheritance hierarchies** in models.
- **Validate data** before persisting it in the database.
- **Perform database operations** in an object-oriented manner.


# 2. Convention Over Configuration
When writing applications with other frameworks, extensive configuration may be required. However, Rails minimizes configuration needs by following conventions.

- Rails assumes **default configurations** that work for most use cases.
- Explicit configuration is only necessary when deviating from the conventions.

## 2.1 Naming Conventions
Active Record follows specific naming conventions for mapping models to database tables:

- **Singular model class names map to plural table names.**
  - Example: `Book` → `books`
- **Rails handles pluralization intelligently.**
  - Example: `Person` → `people`
- **Multi-word class names use UpperCamelCase; table names use snake_case.**
  - Example: `BookClub` → `book_clubs`

### **Examples**
| Model / Class | Table / Schema |
|--------------|----------------|
| Article      | articles       |
| LineItem     | line_items     |
| Product      | products       |
| Person       | people         |

## 2.2 Schema Conventions
Active Record follows specific database schema conventions:

### **Primary Keys**
- Default: `id` (integer, automatically created by migrations)
- For PostgreSQL, MySQL, and MariaDB: `bigint`
- For SQLite: `integer`

### **Foreign Keys**
- Format: `singularized_table_name_id`
  - Example: `order_id`, `line_item_id`
- Used for defining associations between models.

### **Common Column Names**
| Column Name       | Purpose |
|------------------|---------|
| `created_at`     | Timestamp when the record was created |
| `updated_at`     | Timestamp when the record was last updated |
| `lock_version`   | Enables optimistic locking |
| `type`           | Used for Single Table Inheritance (STI) |
| `(association_name)_type` | Stores type for polymorphic associations |
| `(table_name)_count` | Caches count of associated objects (e.g., `comments_count`) |

### **Avoid Reserved Column Names**
- `type` is reserved for **Single Table Inheritance (STI)**.
- If STI (Single Table Inheritance) is not used, choose a more descriptive column name.


# 3. Creating Active Record Models

When generating a Rails application, an abstract `ApplicationRecord` class is created in `app/models/application_record.rb`. This class inherits from `ActiveRecord::Base` and turns a regular Ruby class into an Active Record model.

### Example:
```ruby
class Book < ApplicationRecord
end
```
This creates a `Book` model mapped to a `books` table in the database.

## 3.2 Creating Database Tables
A `books` table with columns `id`, `title`, and `author` can be created using SQL:
```sql
CREATE TABLE books (
  id int(11) NOT NULL auto_increment,
  title varchar(255),
  author varchar(255),
  PRIMARY KEY  (id)
);
```
However, in Rails, tables are typically created using **Active Record Migrations**:
```sh
$ bin/rails generate migration CreateBooks title:string author:string
```
Generated migration:
```ruby
class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author

      t.timestamps
    end
  end
end
```
The migration creates `id`, `title`, `author`, `created_at`, and `updated_at` columns.

## 3.3 Interacting with Active Record Models
Create and interact with an instance of `Book`:
```ruby
book = Book.new
book.title = "The Hobbit"
puts book.title # => "The Hobbit"
```
You can generate both the **model class** and **matching migration** together:
```sh
$ bin/rails generate model Book title:string author:string
```
This creates:
- `app/models/book.rb`
- `db/migrate/20240220143807_create_books.rb`
- Test files

## 3.4 Creating Namespaced Models
To organize models under a folder and namespace:
```sh
$ bin/rails generate model Book::Order
```
Generated structure:
```
app/models/book/order.rb  → class Book::Order < ApplicationRecord
app/models/book.rb       → module Book
```
If `Book` already exists, Rails will prompt for conflict resolution.

To ensure namespaced tables, set a prefix in `app/models/book.rb`:
```ruby
module Book
  def self.table_name_prefix
    "book_"
  end
end
```
This ensures `Book::Order` maps to `book_orders` rather than `orders`.

If `Book` is already a model:
```ruby
class Book < ApplicationRecord
end
```
The `Book::Order` model will still use `book_orders` as the table name without needing a prefix:
```ruby
Book::Order.table_name # => "book_orders"
```