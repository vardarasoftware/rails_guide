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


# 6 Limit and Offset */*/*/*

  -> When querying records, you might want to:
    -> Limit the number of results.
    -> Skip a specific number of records before fetching results.

  -> The .limit(n) method retrieves a maximum of n records.

  ```
  Customer.limit(5)
  ```

  -> Generated SQL:
  ```
  SELECT * FROM customers LIMIT 5;
  ```
  -> Returns only the first 5 customers.


  -> The .offset(n) method skips n records before returning results.

  ```
  The .offset(n) method skips n records before returning results.
  ```

  ->  Generated SQL:
  ```
  SELECT * FROM customers LIMIT 5 OFFSET 30;
  ```
  ->  Skips the first 30 customers and returns the next 5.
  

# 7 Grouping */*/*/*/*

  -> Grouping is used to aggregate data based on a particular field, similar to GROUP BY in SQL.
  -> The .group(:column_name) method groups results based on a field.

  ```
  Order.select("created_at").group("created_at")
  ```
  -> generated SQL:

  ```
  SELECT created_at FROM orders GROUP BY created_at;
  ```
  -> This returns one record per unique date on which orders exist.

  
  ## 7.1 Total of Grouped Items ----

    -> To count how many records belong to each group, chain '.count' after '.group'.
    ```
    Order.group(:status).count
    ```

    -> Generated SQL:
    ```
    SELECT COUNT(*) AS count_all, status FROM orders GROUP BY status;
    ```
    -> This returns a hash with counts for each order status


  ## 7.2 HAVING Conditions ----

    -> The .having method filters grouped results, similar to SQL's HAVING clause.

    ```
    Order.select("created_at as ordered_date, sum(total) as total_price")
     .group("created_at")
     .having("sum(total) > ?", 200)
    ```

    -> Generated SQL:
    ```
    SELECT created_at as ordered_date, sum(total) as total_price
    FROM orders
    GROUP BY created_at
    HAVING sum(total) > 200;
    ```

    -> Returns only the days where total sales exceed $200.

    -> Accessing Aggregated Values

    ```
    big_orders = Order.select("created_at, sum(total) as total_price")
                  .group("created_at")
                  .having("sum(total) > ?", 200)

    big_orders[0].total_price  # Returns the total price for the first grouped date
    ```

    -> The total_price attribute is available for each grouped result.



# 8 Overriding Conditions */*/*/*/*

  ## 8.1 unscope -----

    -> The .unscope method removes specific conditions like order, limit, or where from a query.

    ```
    Book.where("id > 100").limit(20).order("id desc").unscope(:order)
    ```

    -> Generated SQL:
    ```
    SELECT * FROM books WHERE id > 100 LIMIT 20;
    ```
    -> The ORDER BY id DESC is removed.


    ```
    Book.where(id: 10, out_of_print: false).unscope(where: :id)
    ```

    -> Generated SQL:
    ```
    SELECT books.* FROM books WHERE out_of_print = 0;
    ```
    -> The WHERE id = 10 condition is removed.


    ```
    Book.order("id desc").merge(Book.unscope(:order))
    ```

    -> Generated SQL:
    ```
    SELECT books.* FROM books;
    ```
    -> The ordering is removed from the merged query.

  

  ## 8.2 only -----

    -> The .only method keeps only the specified conditions and removes all others.

    ```
    Book.where("id > 10").limit(20).order("id desc").only(:order, :where)
    ```

    -> Generated SQL:
    ```
    SELECT * FROM books WHERE id > 10 ORDER BY id DESC;
    ```
    -> The LIMIT 20 is removed



  ## 8.3 reselect ----

    -> The .reselect method replaces the fields retrieved in a SELECT query.

    ```
    Book.select(:title, :isbn).reselect(:created_at)
    ```

    -> Generated SQL:
    ```
    SELECT books.created_at FROM books;
    ```
    -> It replaces title, isbn with created_at.

    -> Without reselect:

    ```
    Book.select(:title, :isbn).select(:created_at)
    ```

    -> Generated SQL:
    ```
    SELECT books.title, books.isbn, books.created_at FROM books;
    ```
    -> SELECT fields are appended instead of replaced.

  
  ## 8.4 reorder -----

    -> The .reorder method overrides the default order set in the model.

    ```
    class Author < ApplicationRecord
      has_many :books, -> { order(year_published: :desc) }
    end

    Author.find(10).books
    ```

    -> Generated SQL:
    ```
    SELECT * FROM books WHERE author_id = 10 ORDER BY year_published DESC;
    ```
    -> By default, books are sorted by year_published DESC.



    -> Using reorder to Override
    ```
    Author.find(10).books.reorder("year_published ASC")
    ```

    -> Generated SQL:
    ```
    SELECT * FROM books WHERE author_id = 10 ORDER BY year_published ASC;
    ```
    -> ORDER BY is overridden.


  
  ## 8.5 reverse_order -----

    -> The .reverse_order method flips the existing order.

    ```
    Book.where("author_id > 10").order(:year_published).reverse_order
    ```

    -> Generated SQL:
    ```
    SELECT * FROM books WHERE author_id > 10 ORDER BY year_published DESC;
    ```
    -> ASC changes to DESC.


    -> If No Order Exists
    ```
    Book.where("author_id > 10").reverse_order
    ```

    -> Generated SQL:
    ```
    SELECT * FROM books WHERE author_id > 10 ORDER BY books.id DESC;
    ```

    -> Defaults to reversing primary key order.


  
  ## 8.6 rewhere ----

    -> The .rewhere method replaces an existing where condition.

    ```
    Book.where(out_of_print: true).rewhere(out_of_print: false)
    ```

    -> Generated SQL:
    ```
    SELECT * FROM books WHERE out_of_print = 0;
    ```
    -> out_of_print = 1 is replaced with out_of_print = 0.


    -> Without rewhere
    ```
    Book.where(out_of_print: true).where(out_of_print: false)
    ```

    -> Generated SQL:
    ```
    SELECT * FROM books WHERE out_of_print = 1 AND out_of_print = 0;
    ```
    -> This would always return an empty result.

  

  ## 8.7 regroup ----

    -> The .regroup method replaces an existing GROUP BY condition.

    ```
    Book.group(:author).regroup(:id)
    ```

    -> Generated SQL:
    ```
    SELECT * FROM books GROUP BY id;
    ```
    -> GROUP BY author is replaced with GROUP BY id.



    -> Without regroup
    ```
    Book.group(:author).group(:id)
    ```
    
    -> Generated SQL:
    ```
    SELECT * FROM books GROUP BY author, id;
    ```
    -> Both author and id are grouped.



# 9 Null Relation */*/*/*/*/*

  -> The .none method in Active Record is used to return an empty chainable relation. 
  -> This means:
    -> It prevents queries from being executed.
    -> It allows method chaining without breaking the application.
    -> It is useful when you need to return an empty result set instead of nil.

  ```
  Book.none
  ```
  -> Returns an empty ActiveRecord Relation.



  --> Using none in a Method

  ```
  # The highlighted_reviews method below is expected to always return a Relation.
  Book.first.highlighted_reviews.average(:rating)
  # => Returns average rating of a book

  class Book
    # Returns reviews if there are at least 5,
    # else consider this as non-reviewed book
    def highlighted_reviews
      if reviews.count > 5
        reviews
      else
        Review.none # Does not meet minimum threshold yet
      end
    end
  end
  ```

  -> If a book has more than 5 reviews, return the associated reviews.
  -> If a book has 5 or fewer reviews, return Review.none, which behaves like an empty collection.



# 10 Readonly Objects */*/*/*/*

  -> The '.readonly' method in Active Record is used to prevent modifications to fetched records.
  -> If you try to update a readonly record, Rails will raise an 'ActiveRecord::ReadOnlyRecord' 
     exception.
  
  ```
  customer = Customer.readonly.first
  customer.visits += 1
  customer.save # Raises an ActiveRecord::ReadOnlyRecord
  ```

  -> .readonly ensures that the record cannot be modified.
  -> When customer.visits += 1 is attempted, it updates the attribute in memory.
  -> When calling .save, Rails prevents the update and raises an exception.




# 11 Locking Records for Update */*/*/*/*

  -> Locking is used to prevent race conditions when multiple processes try to update the same
     record at the same time. 
  -> Rails provides two types of locking mechanisms:
    -> Optimistic Locking
    -> Pessimistic Locking
  

  ## 11.1 Optimistic Locking -----

    -> Best when conflicts are rare and performance is important.
    -> Optimistic locking assumes that conflicts are rare and allows multiple users to access 
       the same record for editing. 
    -> It works by adding a lock_version column to the table, which keeps track of updates.

    -> When a record is fetched from the database, it includes the 'lock_version' value.
    -> If another process updates the record, it increments the 'lock_version'.
    -> If we try to save the record with an old 'lock_version', it raises an 
       'ActiveRecord::StaleObjectError', preventing data overwrites.

    ```
    c1 = Customer.find(1)
    c2 = Customer.find(1)

    c1.first_name = "Sandra"
    c1.save

    c2.first_name = "Michael"
    c2.save # Raises an ActiveRecord::StaleObjectError
    ```

    -> Here, the second save fails because c1 already updated the record and changed lock_version.

    -> We can change the column name: 
    ```
    class Customer < ApplicationRecord
      self.locking_column = :lock_customer_column
    end
    ```

  
  ## 11.2 Pessimistic Locking -----

    -> Best when conflicts are frequent, and data integrity is critical.
    -> Pessimistic locking prevents conflicts before they happen by locking a record at the 
       database level. 
    -> Whwn a record is locked, no other process can modify it until the transaction is complete.

    -> The lock method locks the record using SQL’s FOR UPDATE or LOCK IN SHARE MODE.
    -> Other transactions must wait until the lock is released.
    -> Usually used inside a transaction.

    ```
    Book.transaction do
      book = Book.lock.first
      book.title = "Algorithms, second edition"
      book.save!
    end
    ```

    -> Generated SQL:
    ```
    BEGIN;
    SELECT * FROM books LIMIT 1 FOR UPDATE;
    UPDATE books SET title = 'Algorithms, second edition' WHERE id = 1;
    COMMIT;
    ````

    -> The FOR UPDATE lock ensures that no other process can update the row until the transaction
       is committed.


    ```
    Book.transaction do
      book = Book.lock("LOCK IN SHARE MODE").find(1)
      book.increment!(:views)
    end
    ```
    -> This allows other queries to read the record but prevents modifications.

    -> If we already have an instance of a record, we can lock it using with_lock:
    ```
    book = Book.first
    book.with_lock do
      book.increment!(:views)
    end
    ```
    -> This ensures that no other process modifies book while inside the block.



# 12 Joining Tables */*/*/*/*/*

  -> In Rails, joins is used to create SQL JOIN clauses when querying the database. 
  -> It helps fetch related records efficiently by leveraging INNER JOIN or custom joins.
  -> Active Record provides two methods for joining tables:
  -> joins → Used for INNER JOIN.
  -> left_outer_joins → Used for LEFT OUTER JOIN.

  ## 12.1 joins -----

    -> Returns records only when there is a match in the related table.
    -> If a record does not have a matching row in the joined table, it will not be included in
       the result.
    

    ### 12.1.1 Using a String SQL Fragment

      -> we can manually define a JOIN condition using raw SQL:
      ```
      Author.joins("INNER JOIN books ON books.author_id = authors.id AND books.out_of_print = FALSE")
      ```

      -> This generated:
      ```
      SELECT authors.* 
      FROM authors 
      INNER JOIN books 
      ON books.author_id = authors.id 
      AND books.out_of_print = FALSE
      ```
      
      -> If you need full control over the SQL query.
      -> If the join condition is complex or involves multiple conditions.

    
    ### 12.1.2 Using Array/Hash of Named Associations 

      -> Active Record lets you use associations defined in models to automatically create JOINs.

      #### 12.1.2.1 Joining a Single Association

      ```
      Book.joins(:reviews)
      ```
      -> If Book has many reviews
      -> Generated SQL:
      ```
      SELECT books.* 
      FROM books 
      INNER JOIN reviews ON reviews.book_id = books.id
      ```

      -> Returns only books that have reviews.
      -> If a book has no reviews, it is not included in the result.


    ### 12.1.3 Joining Multiple Associations

      -> If a Book belongs to an Author and has many Reviews, we can join both tables:

      ```
      Book.joins(:author, :reviews)
      ```
      
      -> Generated SQL:
      ```
      SELECT books.* FROM books
      INNER JOIN authors ON authors.id = books.author_id
      INNER JOIN reviews ON reviews.book_id = books.id
      ```

      -> Returns only books that have both an author and at least one review.
      -> Books without an author or without a review will not be included.


      ### 12.1.3.1 Joining Nested Associations (Single Level)

      -> If a Review belongs to a Customer, and we want books that have been reviewed by a
         customer:
      ```
      Book.joins(reviews: :customer)
      ```

      -> Generated SQL:
      ```
      SELECT books.* 
      FROM books 
      INNER JOIN reviews ON reviews.book_id = books.id
      INNER JOIN customers ON customers.id = reviews.customer_id
      ```

      -> Returns only books that have reviews by a customer.
      -> Books without reviews or books with reviews but no customer are excluded.

      
      #### 12.1.3.2 Joining Nested Associations (Multiple Level)

      -> Example where an Author has Books, a Book has Reviews, a Review belongs to a Customer,
         and a Customer has Orders:
      ```
      Author.joins(books: [{ reviews: { customer: :orders } }, :supplier])
      ```

      -> Generated SQL:
      ```
      SELECT authors.* 
      FROM authors 
      INNER JOIN books ON books.author_id = authors.id
      INNER JOIN reviews ON reviews.book_id = books.id
      INNER JOIN customers ON customers.id = reviews.customer_id
      INNER JOIN orders ON orders.customer_id = customers.id
      INNER JOIN suppliers ON suppliers.id = books.supplier_id
      ```

      -> Books with reviews by customers.
      -> Customers who have placed orders.
      -> Books that have a supplier.

    
    ### 12.1.4 Specifying Conditions on the Joined Tables

      -> we can filter the joined table using .where.
      -> Find customers who have orders created yesterday:
      ```
      time_range = (Time.now.midnight - 1.day)..Time.now.midnight
      Customer.joins(:orders).where("orders.created_at" => time_range).distinct
      ```

      -> Generated SQl:
      ```
      SELECT DISTINCT customers.* 
      FROM customers 
      INNER JOIN orders ON orders.customer_id = customers.id 
      WHERE orders.created_at BETWEEN '2024-02-22 00:00:00' AND '2024-02-23 00:00:00'
      ```

      -> Instead of a string, you can use a hash for better readability:

      ```
      time_range = (Time.now.midnight - 1.day)..Time.now.midnight
      Customer.joins(:orders).where(orders: { created_at: time_range }).distinct
      ```

      -> This works the same way but is more readable and avoids SQL injection risks.

      -> If we have a scope in the Order model

      ```
      class Order < ApplicationRecord
        belongs_to :customer

        scope :created_in_time_range, ->(time_range) {
          where(created_at: time_range)
        }
      end
      ```

      -> we can reuse the scope inside '.joins'
      ```
      time_range = (Time.now.midnight - 1.day)..Time.now.midnight
      Customer.joins(:orders).merge(Order.created_in_time_range(time_range)).distinct
      ```

      -> It reuses logic from the model.
      -> It keeps code clean and maintainable.

  
  ## 12.2 left_outer_joins ----

    -> The left_outer_joins method ensures all primary table records are included, even if 
       there are no matching records in the joined table.
    
    ```
    Customer.left_outer_joins(:reviews).distinct.select("customers.*, COUNT(reviews.*) AS reviews_count").group("customers.id")
    ```
    
    -> Generated SQL:
    ```
    SELECT DISTINCT customers.*, COUNT(reviews.id) AS reviews_count
    FROM customers
    LEFT OUTER JOIN reviews ON reviews.customer_id = customers.id
    GROUP BY customers.id
    ```
    
    -> This retrieves all customers, even those without reviews.
    -> It also calculates the number of reviews each customer has (COUNT(reviews.id)).
    -> Customers without reviews will have a count of 0 instead of being excluded.

  
  ## 12.3 where.associated and where.missing ----

    -> The where.associated(:association) method finds records that have at least one related
       record.
    
    ```
    Customer.where.associated(:reviews)
    ```

    -> Generated SQL:
    ```
    SELECT customers.* 
    FROM customers
    INNER JOIN reviews ON reviews.customer_id = customers.id
    WHERE reviews.id IS NOT NULL
    ```

    -> Uses an INNER JOIN, meaning customers without reviews are excluded.
    -> Equivalent to Customer.joins(:reviews).distinct.


    -> The where.missing(:association) method finds records that do NOT have any related records.

    ```
    Customer.where.missing(:reviews)
    ```

    -> Generated SQL:
    ```
    SELECT customers.* 
    FROM customers
    LEFT OUTER JOIN reviews ON reviews.customer_id = customers.id
    WHERE reviews.id IS NULL
    ```

    -> Uses a LEFT OUTER JOIN but filters out customers who have reviews.
    -> Only customers without reviews are returned.



# 13 Eager Loading Associations */*/*/*/*

  -> Eager loading is used to optimize database queries by reducing the number of queries
     executed when fetching associated records.
  
  ## 13.1 N + 1 Queries Problem ----

    -> When fetching associated records, Active Record executes too many queries, 
       which slows down performance.
    ```
    books = Book.limit(10)

    books.each do |book|
      puts book.author.last_name
    end
    ```

    -> SELECT * FROM books LIMIT 10 → 1 query
    -> Then, for each book: SELECT * FROM authors WHERE authors.id = ? → 10 queries
    -> Total Queries = 1 + 10 = 11 (BAD Performance!)

    #### 13.1.1 Solution: Eager Loading Methods

    -> Active Record provides three methods to solve the N + 1 problem:
      -> includes
      -> preload 
      -> eager_load

  
  ## 13.2 includes ----

    -> Fetches records efficiently using either preload or eager_load depending on conditions.

    ```
    books = Book.includes(:author).limit(10)

    books.each do |book|
      puts book.author.last_name
    end
    ```

    -> Generated SQL:
    ```
    SELECT books.* FROM books LIMIT 10;
    SELECT authors.* FROM authors WHERE authors.id IN (1,2,3,4,5,6,7,8,9,10);
    ```

    -> Loads all authors in a single query instead of executing 10 separate queries.
    -> Reduces queries from 11 to 2 → Better performance!

    ### 13.2.1 Eager Loading Multiple Associations

    ```
    Customer.includes(:orders, :reviews)
    ```
    ->  Loads all customers, orders, and reviews in minimal queries.


    ```
    Customer.includes(orders: { books: [:supplier, :author] }).find(1)
    ```
    ->  Loads orders, books, suppliers, and authors all at once for the customer with id = 1.


    ### 13.2.2 Specifying Conditions on Eager Loaded Associations

    ```
    Author.includes(:books).where(books: { out_of_print: true })
    ```
    ->  Uses a LEFT OUTER JOIN to fetch authors even if they have no books.

    ```
    Author.includes(:books).where("books.out_of_print = true").references(:books)
    ```
    -> Forces a JOIN when using raw SQL conditions.

  

  ## 13.3 preload ---

    -> Loads associated records using separate queries (useful when JOIN is not needed).

    ```
    books = Book.preload(:author).limit(10)

    books.each do |book|
      puts book.author.last_name
    end
    ```

    -> Generated SQL:
    ```
    SELECT books.* FROM books LIMIT 10;
    SELECT authors.* FROM authors WHERE authors.id IN (1,2,3,4,5,6,7,8,9,10);
    ```

    -> When we don’t need joins avoids potential performance issues.
    -> Safer than includes when conditions are not required.

  
  ## 13.4 eager_load ---

    -> Forces a single SQL query using LEFT OUTER JOIN.

    ```
    books = Book.eager_load(:author).limit(10)

    books.each do |book|
      puts book.author.last_name
    end
    ```

    -> Generated SQL:
    ```
    SELECT books.*, authors.* FROM books
    LEFT OUTER JOIN authors ON authors.id = books.author_id
    LIMIT 10;
    ```

    -> When you need conditions on joined tables.
    -> When you want a single SQL query instead of multiple queries.


  ## 13.5 strict_loading---

    -> Ensures all associations are eagerly loaded—throws an error if lazy loading occurs.

    ```
    user = User.strict_loading.first
    user.address.city  # Raises `ActiveRecord::StrictLoadingViolationError`
    ```

    -> Prevents hidden N+1 queries.

    ```
    config.active_record.strict_loading_by_default = true
    ```
    -> Raise an error if any assiciation is lazily loading

  
  ## 13.6 strict_loading! ----

    ```
    user = User.first
    user.strict_loading!
    user.address.city # raises an ActiveRecord::StrictLoadingViolationError
    user.comments.to_a # raises an ActiveRecord::StrictLoadingViolationError
    ```
    -> Forces strict loading mode on this instance.


    ```
    user.strict_loading!(mode: :n_plus_one_only)
    user.address.city # => "Tatooine"
    user.comments.to_a # => [#<Comment:0x00...]
    user.comments.first.likes.to_a # raises an ActiveRecord::StrictLoadingViolationError
    ```

    -> Only raises an error if a true N+1 issue is detected.

  
  ## 13.7 strict_loading option on an association ----

    ```
    class Author < ApplicationRecord
      has_many :books, strict_loading: true
    end
    ```
    -> Ensures books are always eager loaded for authors.



# 14 Scopes */*/*/*/*

  -> Scopes in Rails allow you to define reusable query logic that can be used across your
     application. 
  -> They make queries more readable and maintainable.
  -> A scope is a predefined query that can be called as a method on a model or an association. 
  -> It helps in organizing and reusing common query patterns.

  ```
  class Book < ApplicationRecord
    scope :out_of_print, -> { where(out_of_print: true) }
  end
  ```
  -> Now, instead of writing Book.where(out_of_print: true), you can simply call:
    "Book.out_of_print"

  -> This will return all books that are out of print.
  -> Scopes can also be used on associations:
  ```
  author = Author.first
  author.books.out_of_print
  ```
  
  -> This will return all out-of-print books by a specific author.

  -> we can combine multiple scopes to refine our queries.
  ```
  class Book < ApplicationRecord
    scope :out_of_print, -> { where(out_of_print: true) }
    scope :out_of_print_and_expensive, -> { out_of_print.where("price > 500") }
  end
  ```

  -> Book.out_of_print → returns out-of-print books.
  -> Book.out_of_print_and_expensive → returns out-of-print books that cost more than 500.


  ## 14.1 Passing in Arguments ---

    -> we can pass arguments to scopes, just like method parameters.
    ```
    class Book < ApplicationRecord
      scope :costs_more_than, ->(amount) { where("price > ?", amount) }
    end
    ```

    -> Now we can call

    //-> "Book.costs_more_than(100)"

    -> This will return all books that cost more than 100.

    -> Alternative we can use class method
    ```
    class Book < ApplicationRecord
      def self.costs_more_than(amount)
        where("price > ?", amount)
      end
    end
    ```
    -> Both approaches work, but using scope makes queries more chainable.

  
  ## 14.2 Using Conditionals ---

    -> Scopes can also include conditionals to dynamically change the query.

    ```
    class Order < ApplicationRecord
      scope :created_before, ->(time) { where(created_at: ...time) if time.present? }
    end
    ```

    -> If time is provided, it filters orders created before that time.
    -> If time is nil, it simply returns all orders.

  
  ## 14.3 Applying a Default Scope ----

    -> A default_scope is applied to all queries unless explicitly removed.

    ```
    class Book < ApplicationRecord
      default_scope { where(out_of_print: false) }
    end
    ```

    -> Now, every query will automatically filter out out-of-print books.

    ```
    irb> Book.new
    => #<Book id: nil, out_of_print: false>
    irb> Book.unscoped.new
    => #<Book id: nil, out_of_print: nil>
    ```


  ## 14.4 Merging of Scopes ----

    -> Scopes are combained using AND conditions

    ```
    class Book < ApplicationRecord
      scope :in_print, -> { where(out_of_print: false) }
      scope :out_of_print, -> { where(out_of_print: true) }

      scope :recent, -> { where(year_published: 50.years.ago.year..) }
      scope :old, -> { where(year_published: ...50.years.ago.year) }
    end
    ```

    -> Now we can run 
    ```
    irb> Book.out_of_print.old
    SELECT books.* FROM books WHERE books.out_of_print = 'true' AND 
    books.year_published < 1969
    ```

    -> Overriding Scopes with merge: If you want the latest condition to override the previous one
    ```
    Book.in_print.merge(Book.out_of_print)
    ```
    -> This will return only out-of-print books, overriding the previous in_print scope.

  

  ## 14.5 Removing All Scoping ----

    -> If you want to ignore all scopes (including default_scope), use unscoped.
    ```
    Book.unscoped.load
    ```

    -> Using unscoped with a block:
    ```
    Book.unscoped { Book.out_of_print }
    ```
    -> This will apply Book.out_of_print while ignoring other default scopes.



# 15 Dynamic Finders */*/*/*/*

  -> Active Record automatically provides finder methods for each field in your table. 
  -> These dynamic finders allow us to quickly retrieve records without writing explicit SQL
     queries.

  -> If your Customer model has a field called first_name, we can use:
    -> "Customer.find_by_first_name("Ryan")"
  
  -> This returns the first matching record where first_name = "Ryan".


  -> You can find records by multiple attributes using and between the fields.
    -> " Customer.find_by_first_name_and_orders_count("Ryan", 5) "
  
  -> This finds the first customer where: first_name = "Ryan", orders_count = 5



# 16 Enums */*/*/*/*

  -> Enums in Rails allow you to define a set of named values for an attribute.
  -> storing them as integers in the database but referring to them by human-readable names in
     our code.
  -> When we declare an enum in your model, Rails: 
    -> Stores values as integers in the database
    -> Creates helper methods for querying and updating records
    -> Generates scopes for filtering records based on enum values

  -> Let's define an enum for an Order model:
  ```
  class Order < ApplicationRecord
    enum :status, [:shipped, :being_packaged, :complete, :cancelled]
  end
  ```
  -> This will store the status field as an integer in the database
  -> Once the enum is defined, Rails automatically creates scopes to filter records
  ```
  Order.shipped
  Order.not_shipped
  ```

  -> Generated SQL:
  ```
  SELECT * FROM orders WHERE status = 0;
  ```

  ```
  irb> order = Order.shipped.first
  irb> order.shipped?
  => true
  irb> order.complete?
  => false
  ```

  -> Rails creates setter methods for changing enum values:
  ```
  irb> order = Order.first
  irb> order.shipped!
  UPDATE "orders" SET "status" = ?, "updated_at" = ? WHERE "orders"."id" = ?  [["status", 0], ["updated_at", "2019-01-24 07:13:08.524320"], ["id", 1]]
  => true
  ```

  -> Generated SQL:
  ```
  UPDATE "orders" SET "status" = 0 WHERE "orders"."id" = 1;
  ```

  -> This updates the status field and returns true if successful.



# 17 Understanding Method Chaining */*/*/*/*

  -> Method chaining in Active Record allows you to combine multiple query methods in a single,
     readable statement. 
  -> This makes it easier to filter, join, and retrieve data efficiently.
  -> we can chain methods as long as each method returns an ActiveRecord::Relation.
  -> Methods that return a single object must be at the end of the chain.
  -> The query is not executed immediately—it is sent to the database only when the data is 
     actually needed.
  

  ## 17.1 Retrieving Filtered Data from Multiple Tables ----

    -> Let's say we have a Customer model with Review associations. 
    -> We want to get: customer.id, customer.last_name, review.body
    -> Only for reviews created within the last week.

    ```
    Customer
    .select("customers.id, customers.last_name, reviews.body")
    .joins(:reviews)
    .where("reviews.created_at > ?", 1.week.ago)
    ```


    -> 'select("customers.id, customers.last_name, reviews.body")' → Selects specific columns.
    -> 'joins(:reviews)' → Joins the customers and reviews tables.
    -> 'where("reviews.created_at > ?", 1.week.ago)' → Filters reviews created in the last 7 days.
    -> Executes a single SQL query.

    -> Generated SQL:
    ```
    SELECT customers.id, customers.last_name, reviews.body
    FROM customers
    INNER JOIN reviews
      ON reviews.customer_id = customers.id
    WHERE (reviews.created_at > '2024-02-17')
    ```


  ## 17.2 Retrieving Specific Data from Multiple Tables ---

    -> Now, let's say we have a Book model that belongs to an Author.
    -> We want to find a book titled "Abstraction and Specification in Program Development", 
       and retrieve:
       -> book.id
       -> book.title
       -> author.first_name
    
    ```
    Book
    .select("books.id, books.title, authors.first_name")
    .joins(:author)
    .find_by(title: "Abstraction and Specification in Program Development")
    ```

    -> 'select("books.id, books.title, authors.first_name")' → Selects specific columns.
    -> 'joins(:author)' → Joins the books and authors tables.
    -> 'find_by(title: "Abstraction and Specification in Program Development")' → Searches for 
       a book by title.
    
    -> Generated SQL: 
    ```
    SELECT books.id, books.title, authors.first_name
    FROM books
    INNER JOIN authors
      ON authors.id = books.author_id
    WHERE books.title = $1 [["title", "Abstraction and Specification in Program Development"]]
    LIMIT 1
    ```

    -> Notice the LIMIT 1 → This is because find_by only returns one record.








































  








