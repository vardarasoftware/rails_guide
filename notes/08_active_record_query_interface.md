##  */*/*/*/* Active Record Query Interface /*/*/*/*/*

# 1 What is the Active Record Query Interface? */*/*/*

  -> In Active Record, there is a feature in Ruby on Rails that helps us to interact with the
       database without writing raw SQL queries. 
  -> Instead of writing SQL statements, we can use Ruby methods to fetch, update, and manage 
       data in a more readable and convenient way.
  -> It handles database queries for us.
  -> It works with different databases like MySQL, PostgreSQL, SQLite, etc.
  -> The way us use Active Record is the same, no matter which database we are using.

  ```
  class Author < ApplicationRecord
    has_many :books, -> { order(year_published: :desc) }
  end
  ```
  -> An author can write multiple books.
  -> The books are sorted by year_published in descending order (latest books first).

  ```
  class Book < ApplicationRecord
     belongs_to :supplier
     belongs_to :author
     has_many :reviews
     has_and_belongs_to_many :orders, join_table: "books_orders"

     scope :in_print, -> { where(out_of_print: false) }
     scope :out_of_print, -> { where(out_of_print: true) }
     scope :old, -> { where(year_published: ...50.years.ago.year) }
     scope :out_of_print_and_expensive, -> { out_of_print.where("price > 500") }
     scope :costs_more_than, ->(amount) { where("price > ?", amount) }
  end
  ```
  -> A book belongs to a supplier and an author.
  -> A book can have multiple reviews.
  -> A book can be included in multiple orders.
  -> Some filters (scopes) are defined for books:
    -> in_print: Finds books that are available.
    -> out_of_print: Finds books that are no longer available.
    -> old: Finds books published more than 50 years ago.
    -> out_of_print_and_expensive: Finds books that are out of print and cost more than 500.
    -> costs_more_than(amount): Finds books that cost more than a given amount.

   
  ```
  class Customer < ApplicationRecord
    has_many :orders
    has_many :reviews
  end
  ```
  -> A customer can place multiple orders.
  -> A customer can also write multiple reviews for books.


  ```
  class Order < ApplicationRecord
    belongs_to :customer
    has_and_belongs_to_many :books, join_table: "books_orders"

    enum :status, [:shipped, :being_packed, :complete, :cancelled]

    scope :created_before, ->(time) { where(created_at: ...time) }
  end
  ```
  -> An order belongs to a customer who placed it.
  -> An order can contain multiple books.
  -> The status of an order can be: shipped, being_packed, complete, cancelled.
  -> There's a filter (scope) called created_before(time) that finds orders created before a specific time.


  ```
  class Review < ApplicationRecord
    belongs_to :customer
    belongs_to :book

    enum :state, [:not_reviewed, :published, :hidden]
  end
  ```
  -> A review belongs to both a customer (who wrote it) and a book (being reviewed).
  -> A review can have different states: not_reviewed, published, hidden.


  ```
  class Supplier < ApplicationRecord
    has_many :books
    has_many :authors, through: :books
  end
  ```
  -> A supplier provides multiple books.
  -> A supplier is also indirectly related to multiple authors through books.



# 2 Retrieving Objects from the Database */*/*/*

  -> Active Record, provides a set of methods to help us retrieve data from the database without
     writing SQL queries manually. 
  -> These methods make it easier to interact with your database using Ruby.

  -> The methods are:
    -> annotate
    -> find
    -> create_with
    -> distinct
    -> eager_load
    -> extending
    -> extract_associated
    -> from
    -> group
    -> having
    -> includes
    -> joins
    -> left_outer_joins
    -> limit
    -> lock
    -> none
    -> offset
    -> optimizer_hints
    -> order
    -> preload
    -> readonly
    -> references
    -> reorder
    -> reselect
    -> regroup
    -> reverse_order
    -> select
    -> where

  -> How Finder Methods Work?
    -> we specify what data we need
    -> The query is sent to the database
    -> Active Record creates Ruby objects
    -> Callbacks are triggered

  -> Types of Finder Methods: 
    -> where
    -> group
    -> join
    -> order
    -> find
    -> first/last

  
  ## 2.1 Retrieving a Single Object -----

    -> Active Record provides several different ways of retrieving a single object.

    ### 2.1.1 find

      -> The find method retrieves one or more records by their primary key (ID).

      Example-1

      ```
      irb> customer = Customer.find(10)
      => #<Customer id: 10, first_name: "Ryan">
      ```

      -> This searches for a customer with ID = 10.
      -> If no record is found, it raises an error (ActiveRecord::RecordNotFound).

      -> The SQL equivalent of the above is:
      ```
      SELECT * FROM customers WHERE (customers.id = 10) LIMIT 1
      ```
      
      Example-2

      ```
      # Find the customers with primary keys 1 and 10.
      irb> customers = Customer.find([1, 10]) # OR Customer.find(1, 10)
      => [#<Customer id: 1, first_name: "Lifo">, #<Customer id: 10, first_name: "Ryan">]
      ```

      -> This fetches customers with ID = 1 and ID = 10.
      -> If any of the IDs don’t exist, it raises an error. 


      Example 3: Finding Records with Composite Primary Keys

      ```
      # Find the customer with store_id 3 and id 17
      irb> customers = Customer.find([3, 17])
      => #<Customer store_id: 3, id: 17, first_name: "Magda">
      ```

      -> This finds a customer where store_id = 3 and id = 17.

      -> The SQL equivalent of the above is:
      ```
      SELECT * FROM customers WHERE store_id = 3 AND id = 17
      ```


    
    ### 2.1.2 take

      -> The take method retrieves any one record without ordering.

      Example 1: Get Any One Record

      ```
      irb> customer = Customer.take
      => #<Customer id: 1, first_name: "Lifo">
      ```
      -> This fetches any record.
      -> If no record exists, it returns nil.

      -> SQL equivalent:
      ```
      SELECT * FROM customers LIMIT 1;
      ```

      Example 2: Get Multiple Random Records

      ```
      irb> customers = Customer.take(2)
      => [#<Customer id: 1, first_name: "Lifo">, #<Customer id: 220, first_name: "Sara">]
      ```

      -> This fetches any two random records.

      -> SQL equivalent: 
      ```
      SELECT * FROM customers LIMIT 2;
      ```


    ### 2.1.3 first

      -> The first method retrieves the first record based on primary key by default

      Example 1: Get the First Record

      ```
      irb> customer = Customer.first
      => #<Customer id: 1, first_name: "Lifo">
      ```
      -> Returns the record with the smallest ID by default.
      -> If no record exists, it returns nil.

      -> The SQL equivalent of the above is:
      ```
      SELECT * FROM customers ORDER BY customers.id ASC LIMIT 1
      ```


      Example 2: Get the First 3 Records

      ```
      irb> customers = Customer.first(3)
      => [#<Customer id: 1, first_name: "Lifo">, #<Customer id: 2, first_name: "Fifo">, #<Customer id: 3, first_name: "Filo">]
      ```

      -> Fetches the first three records by default, ordered by ID.

      -> The SQL equivalent of the above is:
      ```
      SELECT * FROM customers ORDER BY customers.id ASC LIMIT 3;
      ```

      Example 3: first With Custom Order

      ```
      irb> customer = Customer.first
      => #<Customer id: 2, store_id: 1, first_name: "Lifo">
      ```

      -> The SQL equivalent of the above is:
      ```
      SELECT * FROM customers ORDER BY customers.store_id ASC, customers.id ASC LIMIT 1
      ```

    
    ### 2.1.4 last

      -> The last method retrieves the last record (based on primary key by default).

      Example 1: Get the Last Record

      ```
      irb> customer = Customer.last
      => #<Customer id: 221, first_name: "Russel">
      ```

      -> Returns the record with the highest ID.
      -> If no record exists, it returns nil.

      -> SQL equivalent:
      ```
      SELECT * FROM customers ORDER BY customers.id DESC LIMIT 1;
      ```


      Example 2: Get the Last 3 Records

      ```
      irb> customers = Customer.last(3)
      => [#<Customer id: 219, first_name: "James">, #<Customer id: 220, first_name: "Sara">, #<Customer id: 221, first_name: "Russel">]
      ```

      -> Fetches the last three records.
      -> SQL equivalent:
      
      ```
      SELECT * FROM customers ORDER BY customers.id DESC LIMIT 3;
      ```


      Example 3: last With Custom Order

      ```
      irb> customer = Customer.order(:first_name).last
      => #<Customer id: 220, first_name: "Sara">
      ```

      -> Fetches the last record sorted by first_name.
      -> SQL equivalent:

      ```
      SELECT * FROM customers ORDER BY customers.first_name DESC LIMIT 1;
      ```

    

    ### 2.1.5 find_by

      -> The find_by method is used to find the first record that matches given conditions. 
      -> It is different from find, which looks for records based only on the primary key (ID).


      Example 1: Find by First Name

      ```
      irb> Customer.find_by first_name: 'Lifo'
      => #<Customer id: 1, first_name: "Lifo">

      irb> Customer.find_by first_name: 'Jon'
      => nil
      ```

      -> This searches for a customer where first_name is "Lifo".
      -> If found, it returns the customer record.
      -> If not found, it returns nil 
      -> Since no customer has 'first_name = "Jon"', it returns nil.

      -> SQL equivalent:
      ```
      SELECT * FROM customers WHERE (customers.first_name = 'Lifo') LIMIT 1;
      ```

      ### 2.1.5.1 Conditions with :id

      -> When using find_by(id: value), make sure you understand how the id column is interpreted.

      ```
      irb> customer = Customer.last
      => #<Customer id: 10, store_id: 5, first_name: "Joe">
      irb> Customer.find_by(id: customer.id) # Customer.find_by(id: [5, 10])
      => #<Customer id: 5, store_id: 3, first_name: "Bob">
      ```

      -> Searches for a customer where id = 10.
      -> Works correctly if id is the primary key.


      Example: Using id_value

      ```
      irb> customer = Customer.last
      => #<Customer id: 10, store_id: 5, first_name: "Joe">
      irb> Customer.find_by(id: customer.id_value) # Customer.find_by(id: 10)
      => #<Customer id: 10, store_id: 5, first_name: "Joe">
      ```

      -> This ensures that id_value returns the correct id column value, preventing errors.

  

  ## 2.2 Retrieving Multiple Objects in Batches -----

    -> When dealing with a large number of records, iterating over them all at once can lead to
       high memory usage and slow performance.

    ```
    # This may consume too much memory if the table is big.
    Customer.all.each do |customer|
      NewsMailer.weekly(customer).deliver_now
    end
    ```
    -> Customer.all.each loads all records into memory at once.
    -> If there are millions of customers, this can crash the application due to memory overload.

    -> Rails provides two memory-efficient methods to process records in chunks:
      -> find_each → Processes one record at a time.
      -> find_in_batches → Processes a batch (group of records) at a time.
    

    ### 2.2.1 find_each

      -> Rails provides find_each, which retrieves records in batches and processes them one at a
         time.

      
      ```
      Customer.find_each do |customer|
        NewsMailer.weekly(customer).deliver_now
      end
      ```

      -> Instead of loading all customers at once, find_each retrieves them in batches
      -> Then, it yields one customer at a time to the block.
      -> After finishing a batch, it automatically fetches the next batch until all records are
         processed.
      
      -> This approach saves memory and is more efficient for large datasets.


      -> Using find_each with Conditions
      ```
      Customer.where(weekly_subscriber: true).find_each do |customer|
        NewsMailer.weekly(customer).deliver_now
      end
      ```
      -> This will only fetch customers who are weekly subscribers and process them in batches.


      ### 2.2.1.1 Options for find_each

      #-> :batch_size

        ```
        Customer.find_each(batch_size: 5000) do |customer|
          NewsMailer.weekly(customer).deliver_now
        end
        ```
        -> This increases the batch size to 5,000 records per batch, reducing the number of
           database queries.
          
      
      #-> :start

        ```
        Customer.find_each(start: 2000) do |customer|
          NewsMailer.weekly(customer).deliver_now
        end
        ```
        -> This skips customers with IDs below 2000 and starts from there.

      
      #-> :finish

        ```
        Customer.find_each(start: 2000, finish: 10000) do |customer|
          NewsMailer.weekly(customer).deliver_now
        end
        ```
        -> This stops at ID 10,000 and doesn’t process any records after that.

      
      #-> :error_on_ignore

        -> If you try to use find_each on a relation that includes an order, it gets ignored by
           default.
      

      #-> :order

        -> By default, find_each orders records by id ASC.
        -> If you want to process them in descending order

        ```
        Customer.find_each(order: :desc) do |customer|
          NewsMailer.weekly(customer).deliver_now
        end
        ```
        -> This processes the latest customers first.

  

    ### 2.2.2 find_in_batches

      -> find_in_batches is similar to find_each, but instead of yielding one record at a time, 
         it yields an entire batch (array of records) at once.
      
      ```
      # Give add_customers an array of 1000 customers at a time.
      Customer.find_in_batches do |customers|
        export.add_customers(customers)
      end
      ```

      -> Instead of fetching all records at once, it retrieves them in batches.
      -> Instead of yielding one record at a time, it yields an entire batch.
      -> This continues until all records are processed.


      ```
      Customer.where(active: true).find_in_batches do |customers|
        export.add_customers(customers)
      end
      ```
      -> Only processes active customers in batches.


      #### 2.2.2.1 Options for find_in_batches

      #-> :batch_size

        -> By default, 1,000 records per batch are processed. 

        ```
        Customer.find_in_batches(batch_size: 2500) do |customers|
          export.add_customers(customers)
        end
        ```
        -> Now each batch contains 2,500 records instead of 1,000.

      #-> :start

        -> By default, find_in_batches starts from the lowest primary key (ID = 1).
        -> If you want to start from a specific ID, use start
        
        ```
        Customer.find_in_batches(batch_size: 2500, start: 5000) do |customers|
          export.add_customers(customers)
        end
        ```
        -> Starts processing customers from ID 5,000.


        #-> :finish

          -> If you only want to process records up to a certain ID, use finish

          ```
          Customer.find_in_batches(finish: 7000) do |customers|
            export.add_customers(customers)
          end
          ```
          -> Stops processing at ID 7,000.

        
        #-> :error_on_ignore

          -> If you try to use 'find_in_batches' on a relation that includes an order, 
             it gets ignored by default.
          


# 3 Conditions */*/*/*

  ## 3.1 Pure String Conditions -----

    -> The 'where' method in Active Record filters records based on conditions, similar to the 
      'WHERE' clause in SQL. 
    -> One way to use it is with pure string conditions, where we directly write the SQL condition
      as a string.
    

  ## 3.2 Array Conditions ------

    -> Array conditions allow you to safely pass dynamic values into SQL queries without risking
       SQL injection. 
    -> Instead of directly inserting values into a query string, we use placeholders (?) and 
       provide the actual values separately.
    
    ```
    Book.where("title = ?", params[:title])
    ```
    -> The '?' acts as a placeholder, and params[:title] is inserted safely.
    -> This prevents SQL injection and ensures proper escaping.

    -> If we want to specify multiple conditions:

    ```
    Book.where("title = ? AND out_of_print = ?", params[:title], false)
    ```
    -> The first '?' is replaced with params[:title].
    -> The second '?' is replaced with false.


    ### 3.2.1 Placeholder Conditions

      -> Instead of using ?, you can use named placeholders for better readability.
      ```
      Book.where("created_at >= :start_date AND created_at <= :end_date",
        { start_date: params[:start_date], end_date: params[:end_date] })
      ```
      -> It improves code readability when dealing with many conditions.
      -> The SQL query is easier to understand.


    ### 3.2.2 Conditions That Use LIKE

      -> 'LIKE' is used for pattern matching
      ```
      Book.where("title LIKE ?", params[:title] + "%")
      ```

      -> If params[:title] = "A%_", it will match unexpected results.
      -> It might also prevent database indexing, making queries slow.

      -> Use sanitize_sql_like to escape wildcards

      ```
      Book.where("title LIKE ?", Book.sanitize_sql_like(params[:title]) + "%")
      ```
      -> This ensures that % and _ are treated as normal characters instead of wildcards.

  

  ## 3.3 Hash Conditions ----

    -> Active Record allows you to use hash-based conditions to improve readability and 
       maintainability.
    -> With hash conditions, you specify field names as keys and the values to filter by in a 
       Ruby-style hash.
    
    ### 3.3.1 Equality Conditions

      -> Hash conditions make equality queries much cleaner.

      ```
      Book.where(out_of_print: true)
      ````

      -> This will generate the SQL :
      ```
      SELECT * FROM books WHERE (books.out_of_print = 1);
      ```


      -> Using Associations in Equality Queries
        -> we can also query by association instead of manually using foreign keys.

      ```
      author = Author.first
      Book.where(author: author)
      Author.joins(:books).where(books: { author: author })
      ```

      -> This makes queries more readable and avoids hardcoding IDs.

      -> This will generate the SQL :
      ```
      Book.where([:author_id, :id] => [[15, 1], [15, 2]])
      ```

    
    ### 3.3.2 Range Conditions

      -> Use ranges for filtering records between two values.

      ```
      Book.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)
      ```

      ->  Generated SQL:
      ```
      SELECT * FROM books WHERE (books.created_at BETWEEN '2024-02-20 00:00:00' AND '2024-02-21 
        00:00:00');
      ```

      -> This simplifies date-based filtering without writing raw SQL.



      -> If you only want "greater than" filtering:
      ```
      Book.where(created_at: (Time.now.midnight - 1.day)..)
      ```

      -> Generated SQL:
      
      ```
      SELECT * FROM books WHERE books.created_at >= '2024-02-20 00:00:00';
      ```

      -> Use .. without an end date for greater than filtering.
      -> Use ..Time.now without a start date for less than filtering.


    ### 3.3.3 Subset Conditions

      -> To filter records matching multiple values, use an array.

      ```
      Customer.where(orders_count: [1, 3, 5])
      ```

      -> Generated SQL:
      ```
      SELECT * FROM customers WHERE customers.orders_count IN (1,3,5);
      ```

      -> Fetching specific categories (Book.where(category: ["Fiction", "Science"]))
      -> Filtering by specific user roles (User.where(role: ["admin", "editor"]))
      -> Selecting from a predefined set of values

  

  ## 3.4 NOT Conditions ----

    -> If you want to exclude certain values from your query, use where.not.

    ```
    Customer.where.not(orders_count: [1, 3, 5])
    ```
    -> Generated SQL:
    ```
    SELECT * FROM customers WHERE (customers.orders_count NOT IN (1,3,5));
    ```

    -> This excludes customers with orders of 1, 3, or 5.

    -> When using where.not, be aware that NULL values behave differently in SQL.

    ```
    Customer.create!(nullable_country: nil)
    Customer.where.not(nullable_country: "UK")
    ```
    -> If a column contains NULL, it won't be included in a NOT query.
    -> This happens because NULL != "UK" evaluates to UNKNOWN, not TRUE.

    -> If you also want to include NULL values in results, explicitly check for them:

    ```
    Customer.where("nullable_country IS NULL OR nullable_country != ?", "UK")
    ```

    -> This ensures that both NULL and non-"UK" values are included.

  

  ## 3.5 OR Conditions ----

    -> To combine conditions with OR, use .or().

    ```
    Customer.where(last_name: "Smith").or(Customer.where(orders_count: [1, 3, 5]))
    ```

    -> Generated SQL:
    ```
    SELECT * FROM customers WHERE (customers.last_name = 'Smith' OR customers.orders_count IN (1,3,5));
    ```

    -> This returns all customers: Named "Smith", OR with an orders_count of 1, 3, or 5


  ## 3.6 AND Conditions-----

    -> In Active Record, AND conditions help narrow down query results by applying multiple 
       filters.
    -> we can simply chain '.where' conditions to apply multiple filters, and Active Record will
       combine them with 'AND' in SQL.
      
    ```
    Customer.where(last_name: "Smith").where(orders_count: [1, 3, 5])
    ```

    -> Generated SQL:
    ```
    SELECT * FROM customers WHERE customers.last_name = 'Smith' AND customers.orders_count IN 
    (1,3,5);
    ```

    -> This filters customers to only include: Last name = "Smith", AND orders_count is 1, 3, or 5


    -> The .and method is useful for combining two different queries into one.
    ```
    Customer.where(id: [1, 2]).and(Customer.where(id: [2, 3]))
    ```

    -> Generate SQL:
    ```
    SELECT * FROM customers WHERE (customers.id IN (1, 2) AND customers.id IN (2, 3));
    ```

    -> This will only return customers who have an ID that appears in both lists.
    -> In this case, ID 2 is the only match, so only Customer with id: 2 will be returned.



# 4 Ordering */*/*/*/*

  -> The order method in Active Record helps sort query results based on one or more fields.

  ```
  Book.order(:created_at)
  # OR
  Book.order("created_at")
  ```
  -> Generated SQL:
  ```
  SELECT * FROM books ORDER BY created_at ASC;
  ```
  -> Default ordering is ascending (ASC) if not explicitly mentioned.


  --> Specifying ASC or DESC

    -> Order by created_at (Descending)
    ```
    Book.order(created_at: :desc)
    # OR
    Book.order("created_at DESC")
    ```

    -> Generated SQL:
    ```
    SELECT * FROM books ORDER BY created_at DESC;
    ```
    -> Newer records will appear first.


    -> Order by created_at (Ascending)
    ```
    Book.order(created_at: :asc)
    # OR
    Book.order("created_at ASC")
    ```
    
    -> Generated SQL:
    ```
    SELECT * FROM books ORDER BY created_at ASC;
    ```
    -> Older records will appear first.



  -> If .order is called multiple times, new orders are added to the existing ones.
  
  ```
  Book.order("title ASC").order("created_at DESC")
  ```
  
  -> Generated SQL:
  ```
  SELECT * FROM books ORDER BY title ASC, created_at DESC;
  ```

  -> This is the same as specifying both fields in one order call.



  --> Ordering with Joined Tables

    -> When using joins or includes, you can order by fields from related tables.
    
    ```
    Book.includes(:author).order(books: { print_year: :desc }, authors: { name: :asc })
    # OR
    Book.includes(:author).order("books.print_year DESC", "authors.name ASC")
    ```

    -> Generated SQL:
    
    ```
    SELECT * FROM books LEFT OUTER JOIN authors ON books.author_id = authors.id
    ORDER BY books.print_year DESC, authors.name ASC;
    ```

    -> First sorts by book print_year (newest first), then by author name (A-Z).

    

# 5 Selecting Specific Fields */*/*/*/*

    -> By default, Model.find retrieves all columns from the database using SELECT *.
    -> To fetch only specific columns, use the '.select' method.
    -> Instead of fetching all fields, you can specify only the required fields.

    ```
    Book.select(:isbn, :out_of_print)
    # OR
    Book.select("isbn, out_of_print")
    ```

    -> Generated SQL:
    ```
    SELECT isbn, out_of_print FROM books;
    ```

    -> Saves memory and speeds up queries by fetching only required data.

    ```
    ActiveModel::MissingAttributeError: missing attribute 'out_of_print' for Book
    ```

    -> Always select all necessary fields before using them.

    -> The .distinct method ensures unique records in the result set.
    ```
    Customer.select(:last_name).distinct
    ```

    -> Generated SQL:
    ```
    SELECT DISTINCT last_name FROM customers;
    ```

    -> Removes duplicate last_name values.

    -> If you used .distinct but later want to include duplicates, use .distinct(false).

    ```
    query = Customer.select(:last_name).distinct
    query.distinct(false) 
    ```





















  








