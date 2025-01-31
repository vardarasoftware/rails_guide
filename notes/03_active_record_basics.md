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

