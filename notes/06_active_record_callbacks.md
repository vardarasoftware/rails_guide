## *******Active Record Callbacks*********

#  1 The Object Life Cycle */*/*/*/*

    --> Active Record callbacks in Rails are special methods that get triggered automatically at
        different stages of an object's life cycle. 
    --> These callbacks allow you to execute custom logic when an object is created, updated, 
        deleted, validated, or even loaded from the database.
    
    --> Callbacks help in:
        -> Adding custom behavior when an object undergoes a state change.
        -> Automating processes
        -> Ensuring data consistency
        -> Logging activities for debugging or monitoring.
    
    --> Callbacks can be triggered before, after, or around an event
    --> Before callbacks: before_validation, before_save, before_create, before_update, 
        before_destroy.
    --> After Callbacks: after_validation, after_save, after_create, after_update, after_destroy,
        after_commit.
    --> Around Callbacks: around_save, around_create, around_update, around_destroy.


    ```
    class BirthdayCake < ApplicationRecord
        after_create -> { Rails.logger.info("Congratulations, the callback has run!") }
    end
    ```

    -> 'after_create' is a callback that runs after a record is successfully created in the
       database.
    -> '{ ... }' is a lambda, a short way to define an anonymous function.
    -> Inside the lambda, 'Rails.logger.info("Congratulations, the callback has run!")' writes a
       message to the Rails log.
    

# 2 Callback Registration */*/*/*/*

    -> Callbacks in Rails allow you to hook into the lifecycle of an object and execute code at
       specific moments, such as before saving, after updating, or before validation. 
    -> To use callbacks, you need to implement them and register them within your model.

    #> 'macro-style class method that calls an ordinary method'
    ```
    class User < ApplicationRecord
        validates :username, :email, presence: true

        before_validation :ensure_username_has_value

        private
        def ensure_username_has_value
            if username.blank?
                self.username = email
            end
        end
    end
    ```

    -> 'before_validation :ensure_username_has_value' registers the method.
    -> 'ensure_username_has_value' is executed before validation runs.
    -> If 'username' is blank, it assigns 'email' to 'username'.


    #> 'macro-style class methods can also receive a block'
    ```
    class User < ApplicationRecord
        validates :username, :email, presence: true

        before_validation do
            self.username = email if username.blank?
        end
    end
    ```

    -> This is useful when the logic is short and fits in a single line

    #> 'pass a proc to the callback'
    ```
    class User < ApplicationRecord
        validates :username, :email, presence: true

        before_validation ->(user) { user.username = user.email if user.username.blank? }
    end
    ```
    -> The proc receives the user object and modifies its username if it's blank.
    -> This is useful when you want a more functional approach.



    #> 'using a custom callback'
    ```
    class User < ApplicationRecord
        validates :username, :email, presence: true

        before_validation AddUsername
        end

        class AddUsername
        def self.before_validation(record)
            record.username = record.email if record.username.blank?
        end
    end
    ```

    -> If the callback logic is complex, moving it to a separate class keeps the model clean.
    -> The 'before_validation AddUsername' registers the 'before_validation' method in the 
       'AddUsername' class.
    -> The method is automatically called before validation.

    ## 2.1 Registering Callbacks to Fire on Life Cycle Events

        -> Callbacks can also be registered to only fire on certain life cycle events.
        -> This can be done using the ':on' option.

        ```
        class User < ApplicationRecord
            validates :username, :email, presence: true

            before_validation :ensure_username_has_value, on: :create

            after_validation :set_location, on: [ :create, :update ]

            private
                def ensure_username_has_value
                    if username.blank?
                        self.username = email
                    end
                end

                def set_location
                    self.location = LocationService.query(self)
                end
        end
        ```

        -> Runs before validation only when a new record is created.
        -> If username is blank, it sets username = email.
        -> Runs after validation during both creation and update.
        -> Calls LocationService.query(self), setting the location.


# 3 Available Callbacks */*/*/*/*

    -> Rails provides callbacks that let us execute custom logic at specific points in an
       object's lifecycle. 
    -> These callbacks are hooked into ActiveRecord operations like creating, updating, or 
       deleting a record.
    
    ## 3.1 Creating an Object
        
        -> Callbacks in Rails allow you to run custom logic at specific points in a record’s
           lifecycle, such as 'validation', 'saving', or 'creating' a new record.

        ## 3.1.1 Validation Callbacks

        -> Validation callbacks are triggered when a record is validated, either:
            -> Directly → Using 'valid?' or 'invalid?'
            -> Indirectly → Using 'create', 'update', or 'save'
        
        ```
        class User < ApplicationRecord
            validates :name, presence: true
            before_validation :titleize_name
            after_validation :log_errors

            private
                def titleize_name
                    self.name = name.downcase.titleize if name.present?
                    Rails.logger.info("Name titleized to #{name}")
                end

                def log_errors
                    if errors.any?
                        Rails.logger.error("Validation failed: #{errors.full_messages.join(', ')}")
                    end
                end
        end
        ```
        
        -> 'before_validation' → Runs before validation
        -> Converts name to title case and Logs the change
        -> Validation Happens (validates :name, presence: true)
        -> If name is empty, it fails.
        -> 'after_validation' → Runs after validation
        -> Logs validation errors


        ## 3.1.2 Save Callbacks
        
        ```
        class User < ApplicationRecord
            before_save :hash_password
            around_save :log_saving
            after_save :update_cache

            private
                def hash_password
                    self.password_digest = BCrypt::Password.create(password)
                    Rails.logger.info("Password hashed for user with email: #{email}")
                end

                def log_saving
                    Rails.logger.info("Saving user with email: #{email}")
                    yield
                    Rails.logger.info("User saved with email: #{email}")
                end

                def update_cache
                    Rails.cache.write(["user_data", self], attributes)
                    Rails.logger.info("Update Cache")
                end
        end
        ```

        -> 'before_save' -- Hashes the password before saving
        -> 'around_save' -- Logs messages before & after saving
        -> Record is saved to the database
        -> 'after_save' -- Caches the user’s data


        ## 3.1.3 Create Callbacks

        ```
        class User < ApplicationRecord
            before_create :set_default_role
            around_create :log_creation
            after_create :send_welcome_email

            private
                def set_default_role
                    self.role = "user"
                    Rails.logger.info("User role set to default: user")
                end

                def log_creation
                    Rails.logger.info("Creating user with email: #{email}")
                    yield
                    Rails.logger.info("User created with email: #{email}")
                end

                def send_welcome_email
                    UserMailer.welcome_email(self).deliver_later
                    Rails.logger.info("User welcome email sent to: #{email}")
                end
        end
        ```
        -> 'before_create' -- Sets a default role if not provided
        -> 'around_create' -- Logs before & after creation
        -> Record is created in the database
        -> 'after_create' -- Sends a welcome email


    ## 3.2 Updating an Object

        -> When updating a record in Rails, callbacks allow us to trigger custom logic before,
           during, or after an update. 
        -> These callbacks ensure that specific actions are executed whenever an update occurs.


        ## 3.2.1 Update Callbacks
            
        -> Whenever you update an object, the following callbacks are triggered in sequence:
            -> before_validation – Runs before validation.
            -> after_validation – Runs after validation.
            -> before_save – Runs before saving (both create & update).
            -> around_save – Wraps the save operation.
            -> before_update – Runs before an update operation.
            -> around_update – Wraps the update operation.
            -> after_update – Runs after an update operation.
            -> after_save – Runs after both create & update.
            -> after_commit / after_rollback – Runs after a transaction is committed or rolled back

        ```
        class User < ApplicationRecord
            before_update :check_role_change
            around_update :log_updating
            after_update :send_update_email

            private
                def check_role_change
                    if role_changed?
                        Rails.logger.info("User role changed to #{role}")
                    end
                end

                def log_updating
                    Rails.logger.info("Updating user with email: #{email}")
                    yield
                    Rails.logger.info("User updated with email: #{email}")
                end

                def send_update_email
                    UserMailer.update_email(self).deliver_later
                    Rails.logger.info("Update email sent to: #{email}")
                end
        end
        ```

        -> before_update: Checks if the role field has changed. If yes, logs the change.
        -> around_update: Logs before and after the update operation.
        -> after_update: Sends an email after updating the user.


        ## 3.2.2 Using a Combination of Callbacks

        ```
        class User < ApplicationRecord
            after_create :send_confirmation_email
            after_update :notify_admin_if_critical_info_updated

            private
                def send_confirmation_email
                    UserMailer.confirmation_email(self).deliver_later
                    Rails.logger.info("Confirmation email sent to: #{email}")
                end

                def notify_admin_if_critical_info_updated
                    if saved_change_to_email? || saved_change_to_phone_number?
                        AdminMailer.user_critical_info_updated(self).deliver_later
                        Rails.logger.info("Notification sent to admin about critical info update for: #{email}")
                    end
                end
        end
        ```

        -> after_create: Sends a confirmation email when a user is newly created.
        -> after_update: If a user updates critical information (email or phone_number), an admin
           is notified.
        

    ## 3.3 Destroying an Object

        ## 3.3.1 Destroy Callbacks

        ```
        class User < ApplicationRecord
            before_destroy :check_admin_count
            around_destroy :log_destroy_operation
            after_destroy :notify_users

            private
                def check_admin_count
                    if admin? && User.where(role: "admin").count == 1
                        throw :abort
                    end
                    Rails.logger.info("Checked the admin count")
                end

                def log_destroy_operation
                    Rails.logger.info("About to destroy user with ID #{id}")
                    yield
                    Rails.logger.info("User with ID #{id} destroyed successfully")
                end

                def notify_users
                    UserMailer.deletion_email(self).deliver_later
                    Rails.logger.info("Notification sent to other users about user deletion")
                end
        end
        ```

        -> check_admin_count runs first.
        -> If this user is the last admin, it aborts the destroy action (throw :abort).
        -> No further callbacks are executed.
        -> check_admin_count runs → passes the check.
        -> log_destroy_operation logs "About to destroy user with ID X".
        -> The user is deleted from the database.
        -> log_destroy_operation logs "User with ID X destroyed successfully".
        -> notify_users sends an email and logs "Notification sent to other users about user
           deletion".
    

    ## 3.4 after_initialize and after_find

        -> These two callbacks are triggered when an Active Record object is created or retrieved
           from the database. 
        -> They help in performing actions automatically when an object is initialized or found.

        ```
        class User < ApplicationRecord
            after_initialize do |user|
                Rails.logger.info("You have initialized an object!")
            end

            after_find do |user|
                Rails.logger.info("You have found an object!")
            end
        end
        ```

        #> 'after_initialize' Callback
            -> This is triggered whenever a new object is instantiated, either by using '.new' or
               when an existing record is loaded from the database.
            -> It runs after the object is created in memory but before it is saved in the 
               database.
            -> Useful for setting default values or logging actions.
        
        #> after_find Callback
            -> This is triggered only when an existing record is retrieved from the database using
               methods like '.find', '.first', '.last', or '.where'.
            -> It runs before after_initialize, if both are defined.
            -> Useful for logging actions or modifying an object after fetching it. 

        
    ## 3.5 after_touch

        ```
        class User < ApplicationRecord
            after_touch do |user|
                Rails.logger.info("You have touched an object")
            end
        end
        ```

        //--> 
        irb> user = User.create(name: "Kuldeep")
        => #<User id: 1, name: "Kuldeep", created_at: "2013-11-25 12:17:49", updated_at: "2013-11-25 12:17:49">

        irb> user.touch
        You have touched an object
        => true
        <--//


## 4 Running Callbacks */*/*/*/*

    🔹 Creation Methods
        -> These methods create a new record in the database and trigger callbacks like
           'before_create', 'after_create', etc.
        'create'
        'create!'

    🔹 Destruction Methods
        -> These methods delete records and trigger callbacks like 'before_destroy', 
           'after_destroy' etc.
        'destroy'
        'destroy!'
        'destroy_all'
        'destroy_by'

    🔹 Saving Methods
        -> These methods save a record (either creating or updating it) and trigger callbacks like
           'before_save', 'after_save', etc.
        'save'
        'save!'
        'save(validate: false)'
        'save!(validate: false)'

    🔹 Updating Methods
        -> These methods update records and trigger callbacks like 'before_update', 'after_update'
           etc.
        'update'
        'update!'
        'update_attribute'
        'update_attribute!'

    🔹 Other Methods That Trigger Callbacks
        'toggle!' → Toggles a 'boolean' attribute and 'saves' the record.
        'touch' → Updates the 'updated_at' timestamp.
    
    --> Additionally, the 'after_find' callback is triggered by the following finder methods:

    -> '.all' → Fetches all records.
    -> '.first' → Fetches the first record.
    -> '.find' → Finds a record by ID.
    -> '.find_by' → Finds a record by specific attributes.
    -> '.find_by!' → Similar to find_by, but raises an error if no record is found.
    -> '.find_by_*' → Dynamic finders like find_by_name, find_by_email, etc.
    -> '.find_by_*!' → Dynamic finders that raise an error if no record is found.
    -> '.find_by_sql' → Fetches records using raw SQL.
    -> '.last' → Fetches the last record.
    -> '.sole' → Ensures exactly one record is found.
    -> '.take' → Fetches a single record without any order.



## 5 Conditional Callbacks */*/*/*/*

    -> Rails allows you to conditionally execute callbacks using the ':if' and ':unless' options. -> These options let you define when a callback should or should not run.

    ## 5.1 Using :if and :unless with a Symbol

        -> A symbol refers to a method name that returns true or false.
        -> ':if' → The callback runs only if the method returns true.
        -> ':unless' → The callback runs only if the method returns false.

        ```
        class Order < ApplicationRecord
            before_save :normalize_card_number, if: :paid_with_card?
        end
        ```
        -> If 'paid_with_card?' returns 'true', the 'before_save' callback (normalize_card_number)
           runs.
        -> If 'paid_with_card?' returns false, the callback is skipped.

    ## 5.2 Using :if and :unless with a Proc

        -> A Proc is an anonymous function that can return true or false.
        -> It is useful for one-liner conditions.

        ```
        class Order < ApplicationRecord
            before_save :normalize_card_number,
                if: ->(order) { order.paid_with_card? }
        end
        ```
        -> The Proc takes an argument (order) and calls order.paid_with_card?.


        ```
        class Order < ApplicationRecord
            before_save :normalize_card_number, if: -> { paid_with_card? }
        end
        ```
        -> This works because Procs execute in the context of the current object.

    
    ## 5.3 Multiple Callback Conditions

        -> we can specify multiple conditions using an array of symbols or Procs.

        #> Multiple Method Names
        ```
        class Comment < ApplicationRecord
            before_save :filter_content,
                if: [:subject_to_parental_control?, :untrusted_author?]
        end
        ```

        -> The callback runs only if both methods return true.

        #> Mixing Methods and Procs

        ```
        class Comment < ApplicationRecord
            before_save :filter_content,
                if: [:subject_to_parental_control?, -> { untrusted_author? }]
        end
        ```
        -> 'subject_to_parental_control?' returns 'true'
        -> 'untrusted_author?' (inside the Proc) returns 'true'


    ## 5.4 Using Both :if and :unless

        -> we can combine :if and :unless in a single callback.

        ```
        class Comment < ApplicationRecord
            before_save :filter_content,
                if: -> { forum.parental_control? },
                unless: -> { author.trusted? }
        end
        ```
        -> The callback runs only if:
            -> 'forum.parental_control?' is true
            -> 'author.trusted?' is false



## 6 Skipping Callbacks */*/*/*/*

    -> Sometimes, you want to update or delete a record in the database without triggering
       callbacks like 'before_save', 'after_save', etc. 
    -> Rails provides special methods that perform database operations directly, skipping all
       callbacks.
        'decrement!'
        'decrement_counter'
        'delete'
        'delete_all'
        'delete_by'
        'increment!'
        'increment_counter'
        'insert'
        'insert!'
        'insert_all'
        'insert_all!'
        'touch_all'
        'update_column'
        'update_columns'
        'update_all'
        'update_counters'
        'upsert'
        'upsert_all'
    
    -> Let's consider a User model where the before_save callback logs any changes to the user's
       email address
    
    ```
    class User < ApplicationRecord
        before_save :log_email_change

        private
            def log_email_change
                if email_changed?
                    Rails.logger.info("Email changed from #{email_was} to #{email}")
                end
            end
    end
    ```
    -> Now, when we update a user’s email normally, the callback will log the change

    //-->
    user = User.find(1)
    user.update(email: 'new_email@example.com')
    <--//


## 7 Suppressing Saving */*/*/*/*

    -> Sometimes, when working with nested associations and callbacks, certain records may be
       automatically created when another record is saved. 
    -> But what if we want to temporarily prevent some records from being saved without disabling
       callbacks permanently?
    -> Rails provides a feature called 'ActiveRecord::Suppressor', which allows us to wrap a block
       of code where you want to avoid saving specific types of records.

    ```
    class User < ApplicationRecord
        has_many :notifications

        after_create :create_welcome_notification

        def create_welcome_notification
            notifications.create(event: "sign_up")
        end
    end

    class Notification < ApplicationRecord
        belongs_to :user
    end
    ```

    -> And the Notification model
    ```
    Notification.suppress do
        User.create(name: "Jane", email: "jane@example.com")
    end
    ```
    -> 'Notification.suppress' prevents any Notification records from being saved within the block.
    -> The User is still created, but the after_create callback does not persist the notification.


## 8 Halting Execution */*/*/*/*

    -> Callbacks like 'before_validation', 'before_save', and 'before_destroy' allow us to 
       interrupt the execution of a database operation.
    -> If a 'before_validation' callback raises an exception, the entire transaction is rolled
       back, and Rails re-raises the error.
    
    ```
    class Product < ActiveRecord::Base
        before_validation do
            raise "Price can't be negative" if total_price < 0
        end
    end

    Product.create # raises "Price can't be negative"
    ```
    -> This crashes the program unexpectedly. 
    -> If other parts of the code were calling '.create', they might not be designed to handle
       exceptions.

    #> Using throw :abort

    -> Instead of raising an exception, you can use 'throw :abort' to gracefully stop the process
       without an error.
    
    ```
    class Product < ApplicationRecord
        before_validation do
            throw :abort if total_price < 0
        end
    end

    Product.create # => false (Product is not saved, but no error is raised)
    ```
    -> 'create' returns false instead of raising an error.
    -> Other code calling '.create' or '.save' can handle the failure smoothly.
    -> Even though throw :abort stops the process without an error when using '.create', it still
       raises an exception when using '.create!' because
       -> "Product.create!"
    -> '.create!' supposed to guarntee that the record is saved
    -> If it fails, it must raise an error.

    
    #> Halting Destroy Operations

    -> we can prevent a record from being deleted using 'throw :abort' inside 'before_destroy'.

    ```
    class User < ActiveRecord::Base
        before_destroy do
            throw :abort if still_active?
        end
    end

    User.first.destroy # => false
    ```
    -> The user remains in the database if 'still_active?' is true.
    -> 'destroy' returns false instead of raising an error.



## 9 Association Callbacks

    -> Association callbacks work like normal ActiveRecord callbacks, but they are triggered when
       objects are added to or removed from an association collection.
    -> 'before_add' --> Before an object is added to the collection
    -> 'after_add' --> After an object is added to the collection
    -> 'before_remove' --> Before an object is removed from the collection
    -> 'after_remove' --> After an object is removed from the collection

    ```
    class Author < ApplicationRecord
        has_many :books, before_add: :check_limit

        private
            def check_limit(_book)
                if books.count >= 5
                    errors.add(:base, "Cannot add more than 5 books for this author")
                    throw(:abort)
                end
            end
    end
    ```

    -> When you try to add a book using 'author.books << book', Rails will call 'before_add:' 
       ':check_limit'.
    -> If the author already has 5 books, 'throw(:abort)' stops the addition.


    -> we can add multipal callback by passing an array.

    ```
    class Author < ApplicationRecord
        has_many :books, before_add: [:check_limit, :calculate_shipping_charges]

        def check_limit(_book)
            if books.count >= 5
                errors.add(:base, "Cannot add more than 5 books for this author")
                throw(:abort)
            end
        end

        def calculate_shipping_charges(book)
            weight_in_pounds = book.weight_in_pounds || 1
            shipping_charges = weight_in_pounds * 2

            shipping_charges
        end
    end
    ```

    -> 'before_add: [:check_limit, :calculate_shipping_charges]' means both methods will run before
       adding a book.
    -> If 'check_limit' fails, the book will not be added, and 'calculate_shipping_charges' won’t
       run.
    

    -> 'before_add' runs before adding an object to an association.
    -> 'throw :abort' stops the addition of the object.
    -> Multiple callbacks can be defined using an array.
    -> Direct updates to 'author_id' do NOT trigger callbacks—only modifying the collection does.
    -> Use these callbacks to control relationships dynamically.


## 10 Cascading Association Callbacks */*/*/*/*

    -> callbacks work in Rails when associated objects are changed. 
    -> It shows how deleting a User also deletes their associated Articles while triggering a
       callback.
    -> User and Article Relationship:
        -> The User model has many Article records.
        -> When a User is deleted, all their Article records should also be deleted.
        -> This is achieved using 'dependent: :destroy' in the 'has_many :articles' association.
    -> Callback in the Article Model:
        -> The Article model defines an 'after_destroy' callback: 'log_destroy_action'.
        -> This callback runs after an Article is deleted.
        -> Inside the callback, it logs the message "Article destroyed".
    
    ```
    class User < ApplicationRecord
        has_many :articles, dependent: :destroy
    end

    class Article < ApplicationRecord
        after_destroy :log_destroy_action

        def log_destroy_action
            Rails.logger.info("Article destroyed")
        end
    end
    ```

    //--> irb> user = User.first
        => #<User id: 1>
    <--//

    -> We fetch the first user from the database.

    //--> irb> user.articles.create!
        => #<Article id: 1, user_id: 1>
    <--//

    -> A new Article is created and associated with this user.
    -> The user_id of the article is set to 1

    //--> irb> user.destroy
        Article destroyed
        => #<User id: 1>
    <--//

    -> The user is deleted.
    -> Because of dependent: :destroy, the associated article is also deleted.
    -> The after_destroy callback in Article runs and logs "Article destroyed".



## 11 Transaction Callbacks */*/*/*/*


    ## 11.1 after_commit and after_rollback

        -> In Rails, callbacks allow us to execute specific code during an object's lifecycle
           events 
        -> Two important callbacks related to database transactions are:
            -> 'after_commit' – Runs only after a transaction successfully commits
            -> 'after_rollback' – Runs only after a transaction fails and rolls back
    
        ```
        class PictureFile < ApplicationRecord
            after_destroy :delete_picture_file_from_disk

            def delete_picture_file_from_disk
                if File.exist?(filepath)
                    File.delete(filepath)
                end
            end
        end
        ```

        -> If we delete a PictureFile, the after_destroy callback will immediately delete the
           corresponding file from disk.
        -> However, if something goes wrong and the transaction is rolled back, the file is
           already deleted.
        -> This leaves our system in an inconsistent state – the database still thinks the file
           exists, but it's gone from the disk.
        

        --> By using the after_commit callback we can account for this case.

        ```
        class PictureFile < ApplicationRecord
            after_commit :delete_picture_file_from_disk, on: :destroy

            def delete_picture_file_from_disk
                if File.exist?(filepath)
                    File.delete(filepath)
                end
            end
        end
        ```

        -> Now, the file is only deleted after the database transaction is successfully committed.
        -> If the transaction is rolled back for any reason, the file remains untouched.


        ```
        class User < ActiveRecord::Base
            after_commit { Rails.logger.info("Transaction committed") }
            after_rollback { Rails.logger.info("Transaction rolled back") }
        end
        ```
        -> If a user is successfully saved, "Transaction committed" is logged.
        -> If something goes wrong and the save fails, "Transaction rolled back" is logged.

        #> Difference Between after_save and after_commit
        
        -> after_save runs before the transaction is committed.
        -> If an error occurs in after_save, the transaction is rolled back
        -> after_commit runs after the transaction is committed. If an error occurs here, the data
           remains saved.
        
        ```
        class User < ActiveRecord::Base
            after_save do
                EventLog.create!(event: "user_saved")
            end
        end
        ```
        -> If EventLog.create! fails, the entire user save is rolled back.

        ```
        class User < ActiveRecord::Base
            after_commit do
                EventLog.create!(event: "user_saved")
            end
        end
        ```

        -> Even if EventLog.create! fails, the user remains saved in the database.


    
    ## 11.2 Aliases for after_commit

        ```
        class PictureFile < ApplicationRecord
            after_commit :delete_picture_file_from_disk, on: :destroy

            def delete_picture_file_from_disk
                if File.exist?(filepath)
                    File.delete(filepath)
                end
            end
        end
        ```

        --> Instead of using 'after_commit' we can use the 'after_destroy_commit'.

        ```
        class PictureFile < ApplicationRecord
            after_destroy_commit :delete_picture_file_from_disk

            def delete_picture_file_from_disk
                if File.exist?(filepath)
                    File.delete(filepath)
                end
            end
        end
        ```

        #> "after_save_commit" callback

        ```
        class User < ApplicationRecord
            after_save_commit :log_user_saved_to_db

            private
                def log_user_saved_to_db
                    Rails.logger.info("User was saved to database")
                end
        end
        ```
        -> The message is logged both on creation and update.


    ## 11.3 Transactional Callback Ordering

        -> By default, 'after_commit' callbacks execute in the order they are defined

        ```
        class User < ActiveRecord::Base
            after_commit { Rails.logger.info("this gets called first") }
            after_commit { Rails.logger.info("this gets called second") }
        end
        ```

        -> In older Rails versions, callbacks ran in reverse order. If we want to restore that
           behavior
        
        //-> 
        In older Rails versions, callbacks ran in reverse order. If you want to restore that behavior
        <-//



        --> after_commit ensures external operations only happen after the database transaction
            succeeds.
        --> after_rollback runs if the transaction fails.
        --> Use after_destroy_commit instead of after_destroy to prevent inconsistencies.
        --> after_commit is different from after_save—it won’t roll back database changes if it
            fails.
        --> If the same record is updated multiple times in a transaction, after_commit only runs 
            once.
        

## 12 Callback Objects */*/*/*/*

    -> When using Active Record callbacks, sometimes the logic inside them is useful for multiple
       models. 
    -> Instead of repeating the same code in different models, we can move the callback logic into
       a separate class
    -> we want to delete a file from the disk after a database record is successfully saved or
       deleted.
    
    ```
    class FileDestroyerCallback
        def after_commit(file)
            if File.exist?(file.filepath)
                File.delete(file.filepath)
            end
        end
    end
    ```

    -> This class defines an 'after_commit' method that takes a model object as a parameter.
    -> It checks if the file exists on the disk and deletes it.
    -> Since 'after_commit' is an instance method, we need to instantiate 'FileDestroyerCallback'
       when using it.
    
    ```
    class PictureFile < ApplicationRecord
        after_commit FileDestroyerCallback.new
    end
    ```

    -> 'FileDestroyerCallback.new' creates a new instance of the callback class.
    -> The 'after_commit' callback will now execute the 'after_commit' method from
       'FileDestroyerCallback'.

    -> Using a Class Method Instead
    ```
    class FileDestroyerCallback
        def self.after_commit(file)
            if File.exist?(file.filepath)
                File.delete(file.filepath)
            end
        end
    end
    ```

    -> 'after_commit' is a class method, meaning we don't need to create an instance of 
       'FileDestroyerCallback'.

    ```
    class PictureFile < ApplicationRecord
        after_commit FileDestroyerCallback
    end
    ```

    -> we can directly pass the class name to 'after_commit', instead of instantiating it.
    -> This makes the callback declaration cleaner and more efficient.

    




