# Active_record_basics
--> Active record is the layer of the system who is responsible for representing data.

--> The "Active record pattern" is a way to interrect with database using objects in programming.
--> It means that each row in database table is represented as an objects in the code.
--> This object  contains both data and method.

# Object Relational Mapping (ORM)

Object relational mapping (ORM) is paly a role of translater between Ruby code and database.
instead of writing complax sql quaries, ORM allows us to use ruby object to do the same work in a easier way.
RDBMS = Relational database management system

# Convention over Configration in Active record
In rails with the help of "Convention over Configration" we don't write extra code to Configure the things.
In many language we have to write a lot of code for create a database table and establish connection,
But in rails if we follow its naming rules, it automaticaly understand the structure without any extra Configration.

Rails use naming Convention that automaticaly connect model to database table. In naming Convention it map a singular model to plural table.
ex- we create a model 'book' that maps automaticaly to a database table named 'books'.
a model named 'usertable' maps to table named 'user_table'.

# CamelCase for models - snake_case for tables 
in ruby class names follow UpperCamelCase but in database tables name follow snake_case(lowercase using underscore)
ex- BookClub -> book_club

polymorphic associations allow a single model to bolend multipal other models that means one single table can be linked to different modules without creating separate foreign keys for each.

# Creating Active Record Models
--> "ApplicationRecord" is the base class for all the Active Record models in our app.
--> Database tabels in Rails are typically created using "Active Record Migrations" 

With the help of this command we can create a books table in our database 
# --> "bin/rails generate migration CreateBooks title:string author:string" <--
That migration creates columns id, title, author, created_at and updated_at.

# Creating Namespaced Models

Namespacing allows us to group, related models into their own Subfolder and give them unique names to avoid the conflict with the other models in the system.

# why we use Namespacing?
--> Better Organization
--> Avoid name conflicts
--> Cleaner code

# --> "bin/rails generate model Book::Order"
this generate command will create 'app/models/book' with 'Book::Order' class name respectively 


# Overriding the Naming Conventions -----------

Rails follows a convention-over-configuration approach, that means it expects things to be named in a certain way. 
If we're working with a legacy database that doesn't follow Rails' naming conventions, we can override defaults names like Table name, Primary Key, Fixtures in test.

# CRUD: Reading and Writing Data -------

CRUD stands for "Create, Read, Update and Delete"
These are the basic operations used to managed the data in database.

Create --> add new data in database
Read --> retrive the data from the database
Update --> modifies the existing data 
Delete --> remove data from the database

# Creat ---
In rails we can create object in different ways using Active Record.
The two main methods are "new" and "create".

In new --- we can create new object in memory but not save in database right away
            we can set its details first then save it later using the "save" method

In create --- we can create new object and saves it to database immediately.

# Read --
Active record provides an easy way to retrieve data from the database using simple methods instead of writing SQL quaries manually.

Retrive All Records --> we can retrive all record from a table "books = Book.all" like this
Retrieve a Single Record --> we an get the first or last record based on their order in the        database 
        "first_book = Book.first
        last_book = Book.last
        book = Book.take"
        like this

Find Specific Records --> we can search for a record based on a specific attribute 
                        "book = Book.find_by(title: "Metaprogramming Ruby 2")
                        book = Book.find(42)"
                        like this

# Update ---
We can modify its details and save the changes back to the database.

Updating a Single Record --> First, we find the record we want to update
                             Then, we change its details
                             Finally, we save the changes, and the record in the database is updated.
                             "book = Book.find_by(title: "The Lord of the Rings")
                              book.title = "The Lord of the Rings: The Fellowship of the Ring"
                              book.save"
                              
Updating Multiple Records at Once --> If we need to update many records at the same time, 
                                      we can do it in bulk.
                                      " Book.update_all(status: "already own")"

# Delete ---
Once you retrieve a record from the database, you can delete it to remove it permanently.

Deleting a Single Record --> First, we find the record you want to delete
                             Then, we call the delete action, which removes it from the database.
                             " book = Book.find_by(title: "The Lord of the Rings")
                               book.destroy "

Deleting Multiple Records --> If we want to remove all records from the table
                              we can delete everything at once.
                              " Book.destroy_by(author: "Douglas Adams")
                                Book.destroy_all "


