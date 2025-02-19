##### */*/*/*/* Active Record Associations */*/*/*/*

# 1 Associations Overview */*/*/*/*

    -> Active Record associations in Rails help us to define how different models (tables) in our
       database are connected. 
    -> This makes it easy to fetch related data without writing complex queries.
    -> Rails automatically sets up the 'primary key' and 'foreign key' to link them properly.
    -> we can easily 'add', 'remove', or 'count books' for an author without manually handling
       database queries.
    
    ## 1.1 Without Associations

        -> If we don’t use Active Record associations, managing related data becomes more manual
           and repetitive.
        
        ```
        class CreateAuthors < ActiveRecord::Migration[8.0]
            def change
                create_table :authors do |t|
                    t.string :name
                    t.timestamps
                end

                create_table :books do |t|
                    t.references :author
                    t.datetime :published_at
                    t.timestamps
                end
            end
        end
        ```

        -> In the migration file, two tables 'authors' and 'books' are created. 
        -> The 'books' table has an 'author_id' column to link 'books' to 'authors', but no
           built-in association is defined in the model.
        
        ```
        class Author < ApplicationRecord
        end

        class Book < ApplicationRecord
        end
        ```

        -> These models do not automatically connect an 'author' to their 'books'.

        //--> @book = Book.create(author_id: @author.id, published_at: Time.now)

        -> 'author_id: @author.id' explicitly tells Rails which 'author' this book belongs to.


        ```
        @books = Book.where(author_id: @author.id)

        @books.each do |book|
            book.destroy
        end

        @author.destroy
        ```

        -> Without associations, Rails does not automatically delete books when an author is
           deleted.
        -> Find all books related to the author.
        -> Loop through and delete each book manually.
        -> Finally, delete the author.


    ## 1.2 Using Associations 

        -> By explicitly defining the relationship between authors and books in the models, Rails automates this process.
        -> Define Associations
        -> In our models, declare that: 
            An Author has many books.
            A Book belongs to an author.

        ```
        class Author < ApplicationRecord
            has_many :books, dependent: :destroy
        end

        class Book < ApplicationRecord
            belongs_to :author
        end
        ```

        -> Now, Rails understands how these two models are linked.
        -> With associations, instead of manually assigning the 'author_id', we can directly
           create a book for an author
        
        ```
        @book = @author.books.create(published_at: Time.now)
        ```
        
        -> Rails automatically fills in the author_id for us.
        -> Instead of manually deleting all books before deleting an author, you can simply do:
            "@author.destroy"



# 2 Types of Associations */*/*/*

    -> Rails provides six types of associations, each used for different relationships between
       models. 
    -> These associations define how objects interact in our database and make working with 
       related data easier.
    
    --> belongs_to
    --> has_one
    --> has_many
    --> has_many :through
    --> has_one :through
    --> has_and_belongs_to_many

    -> Rails associations simplify database relationships, so you don’t have to manually manage
       'JOIN' operations or 'foreign keys'. 
    -> Choosing the right one depends on your data structure and relationships.

    

    ## 2.1 belongs_to

        -> The 'belongs_to' association in Rails connects one model to another, meaning each
           instance of the declaring model is associated with one instance of another model.
        -> It adds a foreign key to the model’s table, linking it to another table.

        ```
        class Book < ApplicationRecord
            belongs_to :author
        end
        ```

        -> This tells Rails that the 'books' table will have an 'author_id' column to store the ID 
           of the associated author.
        -> The migration ensures the 'books' table has a foreign key column (author_id) that links
           to the 'authors' table.
        
        ```
        class CreateBooks < ActiveRecord::Migration[8.0]
            def change
                create_table :authors do |t|
                    t.string :name
                    t.timestamps
                end

                create_table :books do |t|
                    t.belongs_to :author
                    t.datetime :published_at
                    t.timestamps
                end
            end
        end
        ```
        -> This create:-
        -> An 'authors' table with a name column.
        -> A 'books' table with an 'author_id' column that references the 'authors' table.

        -> By default, 'belongs_to' ensures that every Book must have an 'Author'.
        -> If we want to allow a 'Book' without an 'Author', we use 'optional: true'

        ```
        class Book < ApplicationRecord
            belongs_to :author, optional: true
        end
        ```

        -> This allows 'author_id' to be 'NULL', meaning a book can exist without an author.
        -> Even if 'optional: true' allows books without authors, we might still want to enforce
           data consistency at the database level.
        
        ```
        create_table :books do |t|
            t.belongs_to :author, foreign_key: true 
        end
        ```

        -> The 'foreign_key: true' ensures if 'author_id' is present, it must reference a valid
           authors record.
        -> This helps maintain data integrity.


        ## 2.1.1 Methods Added by belongs_to

        -> When we declare a 'belongs_to' association, the declaring class automatically gains
           numerous methods related to the association. 
        -> Some of these are:
            -> association=(associate)
            -> build_association(attributes = {})
            -> create_association(attributes = {})
            -> create_association!(attributes = {})
            -> reload_association
            -> reset_association
            -> association_changed?
            -> association_previously_changed?
        
        ```
        class Book < ApplicationRecord
            belongs_to :author
        end

        class Author < ApplicationRecord
            has_many :books
            validates :name, presence: true
        end
        ```

        ### 2.1.1.1 Retrieving the Association

        -> When using a belongs_to association, we can retrieve the associated object using the
           association name.
        ```
        @author = @book.author
        ```

        -> This fetches the author associated with '@book'.
        -> If no 'author' exists, it returns nil.

        🔹 Handling Cached Associations
            -> Rails caches the associated object once it's retrieved from the database.
            -> If you need to force a fresh read from the database, use 'reload_association'
        ```
        @author = @book.reload_author
        ```

        -> If you just want to remove the cached version, so that Rails fetches a fresh copy next
           time, use 'reset_association'
        ```
        @book.reset_author
        ```


        ###  2.1.1.2 Assigning the Association

        -> we can assign an associated object using 'association='
        ```
        @book.author = @author
        ```
        -> This sets the 'author_id' of '@book' to match the ID of '@author'.
        -> The changes are not saved automatically—you must call save! to persist them.


        -> Building and Creating an Associated Object
        ```
        @author = @book.build_author(author_number: 123, author_name: "John Doe")
        ```

        -> This creates a new Author object but does NOT save it in the database.
        -> '@book.author_id' is automatically set, but '@book.save!' is needed to persist changes.

        -> create_association:
        ```
        @author = @book.create_author(author_number: 123, author_name: "John Doe")
        ```

        -> This creates AND saves the associated object automatically.
        -> 'create_association!' --> Creates, saves, but raises an error if validation fails

        ```
        # This will raise ActiveRecord::RecordInvalid because the name is blank
        begin
            @book.create_author!(author_number: 123, name: "")
        rescue ActiveRecord::RecordInvalid => e
            puts e.message
        end
        ```

        -> If validations fail (e.g., name is blank), an ActiveRecord::RecordInvalid error is
           raised.

        
        ### 2.1.1.3 Checking for Association Changes

        -> we can check if an association has changed before or after saving.
        
        ```
        @book.author # => #<Author author_number: 123, author_name: "John Doe">
        @book.author_changed? # => false
        ```

        -> Since the ; has not changed, 'author_changed?' returns 'false'

        ```
        @book.author = Author.second
        @book.author_changed? # => true
        ```

        -> Now, the author_id is different, so 'author_changed?' returns 'true'

        ```
        @book.save!
        @book.author_changed? # => false
        @book.author_previously_changed? # => true
        ```

        -> 'author_changed?' is now false because changes have been saved.
        -> 'author_previously_changed?' is true because the association was modified in the last
           save.
        

        ### 2.1.1.4 Checking for Existing Associations

        -> To check if an associated object exists, use '.nil?'

        ```
        if @book.author.nil?
            @msg = "No author found for this book"
        end
        ```
        -> return 'true' if the book has no author


        ###  2.1.1.5 Saving Behavior of Associated Objects

        -> Assigning an object to a 'belongs_to' association does NOT save anything automatically.
        -> when the parent object is saved, the association is also saved.

    

    ## 2.2 has_one

        -> A 'has_one' association means that one model is linked to exactly one record in another
           model.
        -> However, the foreign key is stored in the other model.

        ```
        class Supplier < ApplicationRecord
            has_one :account
        end
        ```

        -> Here, Supplier 'has_one' Account.
        -> Supplier does not have an 'account_id' column.



        ```
        class CreateSuppliers < ActiveRecord::Migration[8.0]
            def change
                create_table :suppliers do |t|
                    t.string :name
                    t.timestamps
                end

                create_table :accounts do |t|
                    t.belongs_to :supplier, index: { unique: true }, foreign_key: true
                    t.string :account_number
                    t.timestamps
                end
            end
        end
        ```
        -> 't.belongs_to :supplier' --> Creates a 'supplier_id' column in the accounts table.
        -> Adds a unique index to ensure that one supplier can only have one account.
        -> Adds a foreign key constraint to enforce data integrity.


        ## 2.2.1 Methods Added by has_one

        -> When we declare a 'has_one' association in Rails, the model automatically gets several
           methods that make it easy to interact with the associated record.
        
        ```
        # app/models/supplier.rb
        class Supplier < ApplicationRecord
            has_one :account
        end

        # app/models/account.rb
        class Account < ApplicationRecord
            validates :terms, presence: true
            belongs_to :supplier
        end
        ```

        -> When 'has_one :account' is declared in Supplier, it automatically provides the
           following methods:
            -> account
            -> account=
            -> build_account
            -> create_account
            -> create_account!
            -> reload_account
            -> reset_account
        
        🔹 2.2.1.1 Retrieving the Association

        -> association Method
            -> Returns the associated object if it exists.
            -> Returns nil if no associated object is found.
        
        ```
        @account = @supplier.account
        ```
        -> If the associated object has been previously loaded, Rails caches it and avoids extra 
           queries.


        -> reload_association Method
            -> Forces a fresh database query, ignoring the cached version.

        ```
        @account = @supplier.reload_account
        ```

        -> reset_association Method
            -> Unloads the cached association.
            -> The next time you call '@supplier.account', it will fetch a fresh copy from the
               database.
        
        ```
        @supplier.reset_account
        ```


        🔹 2.2.1.2 Assigning the Association

        -> association= Method
            -> Assigns an object to the association.
            -> Automatically updates the foreign key in the associated record.
        
        ```
        @supplier.account = @account
        ```

        -> build_association(attributes) Method
            -> Creates a new object but doesn’t save it.
            -> Foreign key is set but not persisted.
        
        ```
        @account = @supplier.build_account(terms: "Net 30") 
        ```

        -> create_association(attributes) Method
            -> Creates and saves the associated record immediately.
        
        ```
        @account = @supplier.create_account(terms: "Net 30")  
        ```

        -> create_association! Method
            -> Works like create_association, but raises an error if validation fails.
        
        ```
        # This will raise ActiveRecord::RecordInvalid because the terms is blank
        begin
            @supplier.create_account!(terms: "")
        rescue ActiveRecord::RecordInvalid => e
            puts e.message
        end
        ```


        🔹 2.2.1.3 Checking for Existing Associations

        -> Use .nil? to check if an association exists.
        ```
        if @supplier.account.nil?
            @msg = "No account found for this supplier"
        end
        ```


        🔹 2.2.1.4 Saving Behavior of Associated Objects

        -> When assigning an object to a has_one association: The foreign key is updated.
        -> Both the old and new objects are saved.
        -> If the parent is not saved, the associated object won’t be saved immediately.
        -> Prevents automatic saving of the associated object when the parent is saved.
        -> Cached associations improve performance but can be overridden using 'reload_association'
           or 'reset_association'.
        -> Using 'build_association' lets you work with an object before saving it.
        -> Setting 'autosave: false' gives you more control over when associations are saved.

    

    ## 2.3 has_many

        -> The has_many association in Rails is used to establish a one-to-many relationship
           between models. 
        -> This means that one record in the parent table can be associated with multiple records
           in the child table.
        
        ```
        class Author < ApplicationRecord
            has_many :books  
        end

        class Book < ApplicationRecord
            belongs_to :author  
        end
        ```

        -> The 'has_many :books' in Author establishes that one author can be linked to multiple
           books.
        -> The 'belongs_to :author' in Book sets up a reference to a single author.


        ```
        class CreateAuthors < ActiveRecord::Migration[8.0]
            def change
                create_table :authors do |t|
                    t.string :name
                    t.timestamps
                end
            end
        end
        ```
        -> The authors table stores author details.
        -> Each author will have a unique id assigned automatically.

        ```
        class CreateBooks < ActiveRecord::Migration[8.0]
            def change
                create_table :books do |t|
                    t.belongs_to :author, index: true, foreign_key: true
                    t.datetime :published_at
                    t.timestamps
                end
            end
        end
        ```
        -> The books table includes an 'author_id' column.
        -> Adds the 'author_id' column in the 'books' table.
        -> Creates an index on 'author_id' for better performance.
        -> Enforces a foreign key constraint, ensuring each book references a valid author.


        ## 2.3.1 Methods Added by has_many

            -> These methods allow you to retrieve, modify, delete, and create associated records.

            -> Associated Records
                -> collection
                -> collection<<(object, ...)
                -> collection.delete(object, ...)
                -> collection.destroy(object, ...)
                -> collection=(objects)
                -> collection_singular_ids
                -> collection_singular_ids=(ids)
                -> collection.clear
                -> collection.empty?
                -> collection.size
                -> collection.find(...)
                -> collection.where(...)
                -> collection.exists?(...)
                -> collection.build(attributes = {})
                -> collection.create(attributes = {})
                -> collection.create!(attributes = {})
                -> collection.reload

            ### 2.3.1.1 Managing the Collection

            -> The collection represents all objects associated with the parent.

            ```
            @books = @author.books
            ```
            -> Returns all books associated with the author.
            -> If there are no books, it returns an empty relation.

            -> 'collection.delete(object)' removes the object from the association by setting its
               foreign key to NULL.
            ```
            @author.books.delete(@book1)
            ```
            -> If 'dependent: :destroy' is set, it destroys the book.
            -> If 'dependent: :delete_all' is set, it deletes the book from the database.

            -> collection.destroy(object) calls destroy on each object, ensuring they are removed
               from the database regardless of dependent options.
            ```
            @author.books.destroy(@book1)
            ```
            -> "collection.clear" removes all associated objects.
            -> dependent: :destroy → Calls destroy on each object.
            -> dependent: :delete_all → Deletes all objects directly from the database.
            -> No dependent option → Sets foreign keys to NULL.

            ```
            @author.books.clear
            ```

            ### 2.3.1.2 Assigning the Collection

            -> Replaces the entire collection with new objects.
            ```
            new_books = [Book.find(1), Book.find(2)]
            @author.books = new_books
            ```
            -> Changes are immediately saved to the database.


            ### 2.3.1.3 Querying the Collection

            ```
            @book_ids = @author.book_ids
            ```

            -> Returns an array of IDs of the associated books.

            -->  Checking If the Collection is Empty

            ```
            if @author.books.empty?
                puts "No books found"
            end
            ```

            --> Counting the Number of Associated Objects
            ```
            @book_count = @author.books.size
            ```

            --> Finding Specific Objects in the Collection
            --> collection.find(id) finds a book in the collection by ID.
            ```
            @book = author.books.find(1)
            ```


            --> collection.where(condition) finds books matching certain conditions.
            ```
            @available_books = author.books.where(available: true)
            puts @available_books.first 
            ```

            --> collection.exists?(condition) checks if a book exists in the collection.
            ```
            author.books.exists?(title: "Rails Guide")
            ```


            ### 2.3.1.4 Building and Creating Associated Objects

            -> collection.build creates a new associated object without saving it.
            ```
            @book = author.books.build(title: "New Book")
            ```
            ->The author_id foreign key is automatically set.

            -> collection.create creates and automatically saves the associated object.
            ```
            @book = author.books.create(title: "New Book")
            ```

            -> collection.create! works like create, but raises an error if validation fails.
            ```
            author.books.create!(title: nil) 
            ```


            ### 2.3.1.5 When are Objects Saved?

            -> Assigning objects to a has_many association automatically saves them.
            -> If the parent object is unsaved, associated objects are not saved immediately but
               will be saved when the parent is saved.

    

    ## 2.4 has_many :through

        -> The 'has_many :through' association is used to set up 'many-to-many' relationships
           between two models by connecting them through a third "join" model.
        
        ```
        class Physician < ApplicationRecord
            has_many :appointments
            has_many :patients, through: :appointments
        end

        class Appointment < ApplicationRecord
            belongs_to :physician
            belongs_to :patient
        end

        class Patient < ApplicationRecord
            has_many :appointments
            has_many :physicians, through: :appointments
        end
        ```

        -> A Physician has many Patients but through Appointments.
        -> A Patient has many Physicians but through Appointments.
        -> The Appointment model is the join table that connects Physicians and Patients.


        -> creating database tables

        ```
        class CreateAppointments < ActiveRecord::Migration[8.0]
            def change
                create_table :physicians do |t|
                    t.string :name
                    t.timestamps
                end

                create_table :patients do |t|
                    t.string :name
                    t.timestamps
                end

                create_table :appointments do |t|
                    t.belongs_to :physician
                    t.belongs_to :patient
                    t.datetime :appointment_date
                    t.timestamps
                end
            end
        end
        ```

        -> physicians and patients tables store basic details.
        -> appointments table stores: physician_id, patient_id, appointment_date.


        ->  Using has_many :through for Nested Associations

        -> Imagine we have a Document with multiple Sections, and each Section contains multiple
           Paragraphs. 
        -> Instead of manually traversing each section to get all paragraphs, we can use has_many
           :through for a shortcut.
        
        ```
        class Document < ApplicationRecord
            has_many :sections
            has_many :paragraphs, through: :sections
        end

        class Section < ApplicationRecord
            belongs_to :document
            has_many :paragraphs
        end

        class Paragraph < ApplicationRecord
            belongs_to :section
        end
        ```

        -> Now, you can directly fetch all paragraphs of a document
        
        ```
        @document.paragraphs
        ```


    ### 2.5 has_one :through

        -> The 'has_one :through' association is used when one model is related to another model
           through a third model, but the relationship is one-to-one instead of many-to-many.
        
        ```
        class Supplier < ApplicationRecord
            has_one :account
            has_one :account_history, through: :account
        end

        class Account < ApplicationRecord
            belongs_to :supplier
            has_one :account_history
        end

        class AccountHistory < ApplicationRecord
            belongs_to :account
        end
        ```

        -> This means a supplier has one account and one account history through that account.
        -> An account belongs to a supplier and has one account history.
        -> An account history belongs to an account.

        ```
        class CreateAccountHistories < ActiveRecord::Migration[8.0]
            def change
                create_table :suppliers do |t|
                    t.string :name
                    t.timestamps
                end

                create_table :accounts do |t|
                    t.belongs_to :supplier
                    t.string :account_number
                    t.timestamps
                end

                create_table :account_histories do |t|
                    t.belongs_to :account
                    t.integer :credit_rating
                    t.timestamps
                end
            end
        end
        ```

        -> These the migration will generates.

        -> has_one :through allows Supplier to access AccountHistory without explicitly going
           through Account.
        -> It simplifies queries and makes the code cleaner.
        -> It’s useful when two models are indirectly related via a third model in a one-to-one 
           relationship.
        
    
    ## 2.6 has_and_belongs_to_many

        -> The 'has_and_belongs_to_many' association creates a direct many-to-many relationship  
           between two models without an intermediate model.
        -> This is useful when two models need to be linked but don't need additional data stored 
           in a separate model.
        
        -> Let's take an example of an Assembly (a machine or device) and Part (components used in
           the assembly).
            -> One Assembly can contain many Parts.
            -> One Part can be used in many Assemblies.
            -> There's no need for an extra model like AssemblyPart (unlike has_many :through).
        
        ```
        class Assembly < ApplicationRecord
            has_and_belongs_to_many :parts
        end

        class Part < ApplicationRecord
            has_and_belongs_to_many :assemblies
        end
        ```

        -> An assembly has many parts, and each part can belong to many assemblies.
        -> A part belongs to many assemblies.

        #-> Creating the Join Table
        -> Even though has_and_belongs_to_many doesn't require a separate model, it still requires
           a join table in the database.
        
        ```
        class CreateAssembliesAndParts < ActiveRecord::Migration[8.0]
            def change
                create_table :assemblies do |t|
                    t.string :name
                    t.timestamps
                end

                create_table :parts do |t|
                    t.string :part_number
                    t.timestamps
                end

                # Create a join table to establish the many-to-many relationship between assemblies and parts.
                # `id: false` indicates that the table does not need a primary key of its own
                create_table :assemblies_parts, id: false do |t|
                # creates foreign keys linking the join table to the `assemblies` and `parts` tables
                    t.belongs_to :assembly
                    t.belongs_to :part
                end
            end
        end
        ```
        -> id: false → The join table does not need its own primary key.
        -> t.belongs_to → Creates foreign keys linking the join table to assemblies and parts.
        

        ### 2.6.1 Methods Added by has_and_belongs_to_many

        -> When you use 'has_and_belongs_to_many' (HABTM) in a Rails model, Rails automatically 
           provides a set of methods to help manage the many-to-many relationship between the two 
           models.
        
        -> If we have a Part model that has a many-to-many relationship with an Assembly model, 
           we would define it like this
        ```
        class Part < ApplicationRecord
            has_and_belongs_to_many :assemblies
        end
        ```
        
        -> This means a Part can be associated with multiple Assemblies, and an Assembly can be 
           associated with multiple Parts.
        
        -> Now, any instance of Part (part = Part.find(1)) can use the following methods:
            -> assemblies
            -> assemblies<<(object, ...)
            -> assemblies.delete(object, ...)
            -> assemblies.destroy(object, ...)
            -> assemblies=(objects)
            -> assembly_ids
            -> assembly_ids=(ids)
            -> assemblies.clear
            -> assemblies.empty?
            -> assemblies.size
            -> assemblies.find(...)
            -> assemblies.where(...)
            -> assemblies.exists?(...)
            -> assemblies.build(attributes = {}, ...)
            -> assemblies.create(attributes = {})
            -> assemblies.create!(attributes = {})
            -> assemblies.reload

        


        #### 2.6.1.1 Managing the Collection

        -> These methods help us retrieve, add, and remove associated objects.
        ```
        @assemblies = @part.assemblies
        ```
        -> This returns all assemblies linked to the @part.
        -> If there are no related records, it returns an empty collection.


        ```
        @part.assemblies << @assembly1
        ```
        -> Adds @assembly1 to @part.
        -> This creates an entry in the join table but does not create a new Assembly record.
        -> Aliases: concat and push also do the same thing.


        ```
        @part.assemblies.delete(@assembly1)
        ```
        -> Removes the relationship between '@part' and '@assembly1' from the join table, but does
           not delete @assembly1 itself.


        ```
        @part.assemblies.destroy(@assembly1)
        ```
        -> Works just like delete, removes only the relationship but does not delete the 
           @assembly1 record.
        


        #### 2.6.1.2 Assigning the Collection

        -> These methods allow you to replace the existing associations with new ones.


        ```
        @part.assemblies = [@assembly1, @assembly2]
        ```
        -> Removes existing associations and replaces them with @assembly1 and @assembly2.
        -> The join table is updated automatically.


        ```
        @part.assembly_ids = [1, 2, 3]
        ```
        -> Works like collection=, but uses IDs instead of object references.



        #### 2.6.1.3 Querying the Collection

        -> These methods help you check, count, and find associated records.

        ```
        @assembly_ids = @part.assembly_ids
        ```
        -> Returns an array of assembly IDs.


        ```
        @part.assemblies.empty?
        ```
        -> Returns true if there are no associated objects.


        ``` 
        @part.assemblies.size
        ```
        -> Returns the number of associated objects.


        ```
        @assembly = @part.assemblies.find(1)
        ```
        -> Finds an associated assembly by its ID.

        
        ```
        @new_assemblies = @part.assemblies.where("created_at > ?", 2.days.ago)
        ```
        -> Finds assemblies created in the last 2 days.
        -> The query is executed only when the records are accessed (lazy loading).

        
        ```
        @part.assemblies.exists?(1)
        ```
        -> Checks if there is an assembly with ID 1 associated with @part.


        #### 2.6.1.4 Building and Creating Associated Objects

        -> These methods help you create new associated objects.

        ```
        @assembly = @part.assemblies.build({ assembly_name: "Transmission housing" })
        ```
        -> Creates a new Assembly object in memory (not yet saved).
        -> The association is set, but the record is not saved to the database.


        ```
        @assembly = @part.assemblies.create({ assembly_name: "Transmission housing" })
        ```
        -> Creates an Assembly object, associates it with @part, and saves it to the database.


        ```
        Creates an Assembly object, associates it with @part, and saves it to the database.
        ```
        -> Works like create, but raises an error if the record is invalid.


        ```
        @assemblies = @part.assemblies.reload
        ```
        -> Forces Rails to fetch the latest data from the database.
        -> Useful when the collection may have changed since the last retrieval.


        #### 2.6.1.5 When are Objects Saved?

        -> When you assign an object to a HABTM association, it is automatically saved 
        -> If multiple objects are assigned, they are all saved at once.
        -> If an object fails validation, the whole assignment is canceled.
        -> If the parent object is new, associated objects are not saved until the parent is
           saved.
        -> To add an associated object without saving it immediately, use build.



# 3 Choosing an Association */*/*/*/*

    ## 3.1 belongs_to vs has_one

        -> In Rails, when setting up a one-to-one relationship between two models, you need to decide
           between belongs_to and has_one. 
        -> The key difference lies in where the foreign key is stored and the direction of ownership.

        -> belongs_to → The model containing the foreign key.
        -> has_one → The model that owns the other model.

        ```
        class Supplier < ApplicationRecord
            has_one :account
        end

        class Account < ApplicationRecord
            belongs_to :supplier
        end
        ```

        -> The 'accounts' table will store a 'supplier_id' column as a foreign key.
        -> 'Supplier' will have one 'Account', while 'Account' will belong to a 'Supplier'.
        

        ```
        class CreateSuppliers < ActiveRecord::Migration[8.0]
            def change
                create_table :suppliers do |t|
                    t.string :name
                    t.timestamps
                end

                create_table :accounts do |t|
                    t.belongs_to :supplier_id
                    t.string :account_number
                    t.timestamps
                end

                add_index :accounts, :supplier_id
            end
        end
        ```

        -> The suppliers table contains supplier details.
        -> The accounts table contains: supplier_id, account_number
        -> The foreign key (supplier_id) is placed in the accounts table because account belongs
           to Supplier.
        -> belongs_to indicates that this model stores the foreign key.


    ## 3.2 has_many :through vs has_and_belongs_to_many

        -> In Rails, you can establish a many-to-many relationship between models in two ways:
        -> has_many :through
        -> has_and_belongs_to_many 


        ```
        class Assembly < ApplicationRecord
            has_many :manifests
            has_many :parts, through: :manifests
        end

        class Manifest < ApplicationRecord
            belongs_to :assembly
            belongs_to :part
        end

        class Part < ApplicationRecord
            has_many :manifests
            has_many :assemblies, through: :manifests
        end
        ```

        -> An Assembly is made of Parts.
        -> The Manifest is the join model that connects them and can store additional details.
        

        ```
        class Assembly < ApplicationRecord
            has_and_belongs_to_many :parts
        end

        class Part < ApplicationRecord
            has_and_belongs_to_many :assemblies
        end
        ```

        -> This join table does not have a primary key and cannot store extra attributes.



# 4 Advanced Associations */*/*/*/*

    ## 4.1 Polymorphic Associations

        -> Polymorphic associations allow a model to belong to multiple other models using a
           single association. 
        -> This is useful when different models share a common relationship with another model.


        ```
        class Picture < ApplicationRecord
            belongs_to :imageable, polymorphic: true
        end

        class Employee < ApplicationRecord
            has_many :pictures, as: :imageable
        end

        class Product < ApplicationRecord
            has_many :pictures, as: :imageable
        end
        ```

        -> The Picture model belongs to an imageable entity.
        -> The Employee and Product models have many pictures through the imageable association.


        -> To set this up in the database, we need:
            -> imageable_id → Stores the ID of the related model (Employee or Product).
            -> imageable_type → Stores the model name ("Employee" or "Product").
        
        ```
        class CreatePictures < ActiveRecord::Migration[8.0]
            def change
                create_table :pictures do |t|
                    t.string :name
                    t.belongs_to :imageable, polymorphic: true
                    t.timestamps
                end
            end
        end
        ```

        -> A single table handles pictures for multiple models.
        -> No need for separate foreign keys like 'employee_id' and 'product_id'.


    
    ## 4.2 Models with Composite Primary Keys

        -> Rails automatically infers primary key-foreign key relationships when dealing with
           associations. 
        -> However, when a table has a composite primary key, Rails defaults to using only one
           column.
        -> To correctly handle composite primary keys in associations, we must explicitly define
           them in your models.
        -> A composite primary key is when two or more columns together uniquely identify a
           record.
        -> Rails assumes that every table has a single id column as the primary key. 
        -> When working with composite primary keys, it will likely default to using only id in 
           associations unless explicitly specified.
        

    
    ## 4.3 Self Joins

        -> A self-join is a technique where a table is joined with itself to establish a
           hierarchical relationship between records. 
        -> This is useful when a model needs to reference another record of the same model.

        ```
        class Employee < ApplicationRecord
            # an employee can have many subordinates.
            has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"

            # an employee can have one manager.
            belongs_to :manager, class_name: "Employee", optional: true
        end
        ```

        -> 'has_many :subordinates' this means one employee can have multiple subordinates.
        -> We explicitly set 'class_name: "Employee"' to tell Rails that the associated model is
           the same table.
        -> The foreign key 'manager_id' in the employees table is used to identify the manager.
        -> 'belongs_to :manager' this means an employee can have one manager.
        -> 'class_name: "Employee"' tells Rails to look for the manager in the same table.
        -> 'optional: true' allows top-level managers to exist without having a manager.



        ```
        class CreateEmployees < ActiveRecord::Migration[8.0]
            def change
                create_table :employees do |t|
                # Add a belongs_to reference to the manager, which is an employee.
                    t.belongs_to :manager, foreign_key: { to_table: :employees }
                    t.timestamps
                end
            end
        end
        ```

        -> t.belongs_to :manager, foreign_key: { to_table: :employees } = this adds a 
           'manager_id' column to the employees table.
        -> The foreign_key: { to_table: :employees } ensures that manager_id references another
           employee.
        


# 5 Single Table Inheritance (STI) */*/*/*/*

    -> STI is a design pattern in Rails that allows multiple models to share a single database
       table while behaving as different classes.
    -> This is useful when different entities share common attributes and behavior, but also have
       some unique behaviors.
    
    ## 5.1 Generating the Base Vehicle Model

        ```
        bin/rails generate model vehicle type:string color:string price:decimal{10.2}
        ```

        -> type is a special column used by Rails to store the subclass name (e.g., Car,
           Motorcycle, etc.).
        -> Rails automatically maps subclasses to the parent table using the type column.
    
    
    ## 5.2 Generating Child Models

        ```
        bin/rails generate model car --parent=Vehicle
        ```

        -> This generates:-

        ```
        class Car < Vehicle
        end
        ```

    
    ## 5.3 Creating Records

        ```
        Car.create(color: "Red", price: 10000)
        ```

        -> Since all models share the vehicles table, Rails automatically sets the type column.
        -> This will generate the SQL:-

        ```
        INSERT INTO "vehicles" ("type", "color", "price") VALUES ('Car', 'Red', 10000)
        ```


    ## 5.4 Querying Records
        
        ```
        Car.all
        ```
        -> Rails ensures that queries return only relevant records.
        -> This will generate the SQL:-

        ```
        SELECT "vehicles".* FROM "vehicles" WHERE "vehicles"."type" IN ('Car')
        ```


    ## 5.5 Adding Specific Behavior

        -> Each subclass can define its own methods.
        ```
        class Car < Vehicle
            def honk
                "Beep Beep"
            end
        end
        ```
        
        -> Now, we can do:
        ```
        car = Car.first
        car.honk  # => "Beep Beep"
        ```

    
    ## 5.6 Controllers

        ```
        class CarsController < ApplicationController
            def index
                @cars = Car.all
            end
        end
        ```

        -> Each subclass can have its own controller.


    ## 5.7 Overriding the inheritance column

        -> By default, Rails uses the type column for STI.
        -> If we're working with a legacy database where the column name is different, 
           we can override it.
        
        ```
        class Vehicle < ApplicationRecord
            self.inheritance_column = "kind"
        end
        ```

    
    ## 5.8 Disabling the inheritance column

        -> If we don't want Rails to use STI, we can disable it.

        ```
        class Vehicle < ApplicationRecord
            self.inheritance_column = nil
        end
        ```

    
    ## 5.9 Considerations

        -> Less duplication – Only one table instead of multiple.
        -> Easier queries – Querying Vehicle.all fetches all types.
        -> Code reusability – Shared logic in Vehicle for all subclasses.

        -> Table bloat – The table will have unused columns for some subclasses.
        -> Data integrity issues – Need to ensure subclass-specific fields are correctly handled.
        -> Hard to scale – If subclasses grow with unique attributes, STI becomes inefficient.



# 6 Delegated Types */*/*/*/*

    -> Delegated Types is an alternative to Single Table Inheritance (STI) that prevents table
       bloat. 
    -> Instead of storing all attributes in a single table, Delegated Types splits common and
       unique attributes into separate tables.
    -> If a vehicles table has Car, Motorcycle, and Bicycle, it must store all possible
       attributes for every type, leading to unused columns in many records.
    -> Delegated Types solves this by keeping shared attributes in a common table and moving 
       specific attributes to individual tables.
    

    ## 6.1 Setting up Delegated Types

        -> Instead of using STI, Delegated Types uses a shared table (entries) to track different
           models and delegates behavior to subclass-specific tables.
        -> Create a base model (Entry) to store shared attributes.
        -> Create separate models (Message, Comment) to store subclass-specific attributes.
        -> Use delegated_type to link the Entry model with the subclasses.

    
    ## 6.2 Generating Models

        ```
        bin/rails generate model entry entryable_type:string entryable_id:integer
        ```
        -> entryable_type stores the model name (e.g., "Message", "Comment").
        -> entryable_id stores the ID of the related record.

        -> Then, we will generate new Message and Comment models for delegation:
        ``` 
        bin/rails generate model message subject:string body:string
        bin/rails generate model comment content:string
        ```

        -> After running the generators, our models should look like this:

        ```
        # Schema: entries[ id, entryable_type, entryable_id, created_at, updated_at ]
        class Entry < ApplicationRecord
        end

        # Schema: messages[ id, subject, body, created_at, updated_at ]
        class Message < ApplicationRecord
        end

        # Schema: comments[ id, content, created_at, updated_at ]
        class Comment < ApplicationRecord
        end
        ```


    ## 6.3 Declaring delegated_type

        -> We define delegated_type in the Entry model
        ```
        class Entry < ApplicationRecord
            delegated_type :entryable, types: %w[ Message Comment ], dependent: :destroy
        end
        ```

        -> The entryable field refers to either Message or Comment.
        -> 'dependent: :destroy' ensures that if an Entry is deleted, the associated record is 
           also deleted.

    
    ## 6.4 Defining the Entryable Module

        -> Since Message and Comment belong to Entry, we create a module to handle this 
           association.
        ```
        module Entryable
            extend ActiveSupport::Concern

            included do
                has_one :entry, as: :entryable, touch: true
            end
        end
        ```

        -> has_one :entry, as: :entryable links the subclass (Message, Comment) to Entry.
        -> touch: true updates Entry's timestamp whenever Message or Comment changes.


        -> Now, include this module in Message and Comment

        ```
        class Message < ApplicationRecord
            include Entryable
        end

        class Comment < ApplicationRecord
            include Entryable
        end
        ```

    

    ## 6.5 Object creation

        ```
        Entry.create!(entryable: Message.new(subject: "hello!"))
        ```
        -> A Message with subject: "hello!".
        -> An Entry linked to that Message.


    
    ## 6.6 Adding further delegation


        -> We can delegate methods from Entry to Message and Comment.
        -> Message#title → subject
        -> Comment#title → a truncated version of content.


        ```
        class Entry < ApplicationRecord
            delegated_type :entryable, types: %w[ Message Comment ]
            delegate :title, to: :entryable
        end

        class Message < ApplicationRecord
            include Entryable

            def title
                subject
            end
        end

        class Comment < ApplicationRecord
            include Entryable

            def title
                content.truncate(20)
            end
        end
        ```








