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
