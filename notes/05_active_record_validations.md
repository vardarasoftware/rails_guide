#####  Active Record Validations ######

# 1 Validations Overview------

    -> Validations in Rails ensure that only valid data is saved into the database. 
    -> They help maintain data integrity by checking conditions before records are persisted.

    //-->
    class Person < ApplicationRecord
        validates :name, presence: true
    end
    <--//

    -> here, validates ensure that 'name' cannot be blank
    -> If Person can be created with 'name', it is valid and can be saved

    //-->
    Person.create(name: "John Doe").valid?
    Person.create(name: nil).valid?
    <--//

    -> here first one is valid because it gives the name and can be stored in database
    -> the second instance is invalid because it gives the name nil and won't be saved in database

    ## 1.1 Why Use Validations?

        Model-level Validations:-
        -> model level validations are the best way ensure that only valid data is saved into your
           database because
           They work independently of the database
           They cannot be bypass by end user
           They are easy test and maintain
        
        -> There are different levels at which data can be validated, each with its own benefits
           and drawbacks
        
        #> Database Constraints & Stored Procedures
        -> Constraints are enforced directly by the database 
        -> Ensure data integrity at the database level
        -> Cannot be bypassed by any application or direct database access
        -> make our application database dependent
        -> harder to test and maintain as caompare to model level validation

        #> Client-Side Validations
        -> Uses Javascript to check inpute fields before submiting the form
        -> Provide immediate feedback to users
        -> Improves user exprienceby proventing unnecessary server requests
        -> can be bypassed if JavaScript disabled

        #> Controller-Level Validations
        -> implementing the check inside the controller before saving data
        -> Can handle complex validation related to business logic
        -> difficult to test and debug

    
    ## 1.2 When Does Validation Happen?

        -> In Rails, Active Record objects represent rows in a database table. These objects can exist in two states:

        -> Unsaved (New) Objects -- Not yet stored in the database.
        -> Saved (Persisted) Objects -- Stored in the database.

        //-->
        p = Person.new(name: "John Doe")
        p.new_record?
        p.save
        p.new_record?
        <--//
        
        -> Here, "p = Person.new(name: "John Doe")" is initialize a new record 
        -> Our record is initialize or not for checking this we use 'p.new_record?'
        -> If it show 'true' that means our record is initialize but not saved in database
        -> For saving this into our database we use '.save' method like 'p.save'
        -> Once our record is save into our database it will show 'false' when we run again
           'p.new_recoed'
        
        --> Before an object is saves, Rails runs validation to ensure data integrity
            -> If validation pass, the 'INSERT/UPDATE' is executed
            -> If validation fails, the record not saved into the database

        -> The following methods trigger validations, and will save the object to the database
           only if the object is valid:

        -> 'create'
        -> 'create!'
        -> 'save'
        -> 'save!'
        -> 'update'
        -> 'update!'

        --> Difference between Bang(!) or Non-Bang method
            -> Methods with ! (bang) --> Raise an exception if validation fails.
            -> Methods without ! --> Return false if validation fails.

    
    ## 1.3 Skipping Validations

        -> These methods in Rails allow you to update or insert records in the database 
           while skipping validations
        -> Methods like 'increment!', 'decrement!', 'toggle!', 'touch', and 'update_attribute' 
           These modify a single record without running validations.
        -> Bulk update methods like 'update_all', 'update_columns', and 'update_counters'
           These update multiple records at once without checking validations.
        -> Insert methods like 'insert', 'insert!', 'insert_all', and 'upsert'
           These add new records directly into the database without running validations or callbacks.
        -> Using 'save(validate: false)' This allows us to save an object without running validations,
           which can be risky.


    ## 1.4 valid? and invalid?
        
        -> we can manually check if an object is valid by calling ".valid?"
            -> If all validations pass = "true"
            -> If any validation fails = "false"
        
        //--> 
        class Person < ApplicationRecord
            validates :name, presence: true
        end
        <--//

        //-->
        Person.create(name: "John Doe").valid?
        Person.create(name: nil).valid?
        <--//

        -> In this example the first '.valid?' give output 'true' because 'name' was present there.
        -> In second '.valid?' we get output 'false' because 'name' was nil.

        //-->
        p = Person.new
        p.errors.size
        p.valid?
        p.errors.objects.first.full_message
        p = Person.create
        p.errors.objects.first.full_message
        p.save
        p.save!
        Person.create!
        <--//

        -> When we create an object using 'new', Rails does not check validations immediately.
        -> Validations only run when calling '.save', '.create', or '.update'.
        -> '.save!' and '.create!' work like '.save' and '.create', but they raise an error if
           validations fail.
        -> 'invalid?' is simply the opposite of 'valid?'
        -> It returns true if the object has errors (is invalid).
        -> It returns false if the object is valid.

    
    ## 1.5 errors[]

        -> When Rails runs validations on an object, it collects all validation failures in the
           '.errors' collection. 
        -> If we want to check whether a specific attribute has errors.
        -> we can use "errors[:attribute]". This returns an array of error messages for that
           attribut
        -> 'errors[:attribute]' checks validation errors for a single attribute 
        -> It’s different from 'invalid?', which checks if the entire object is invalid.
        
        //--> 
        Person.new.errors[:name].any?
        Person.create.errors[:name].any?
        <--//




