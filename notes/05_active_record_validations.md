# *******Active Record Validations*******

## 1 Validations Overview------

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


## 2 Validation Helpers-----

    -> Rails provides pre-defined validation helpers that we can use inside our model to enforce
       rules on attributes. 
    -> These helpers make it easy to define common validation logic without writing extra code.
    -> If a validation fails, an error message is added to the '.errors' collection and linked to
       the specific attribute that failed validation.
    -> We can use a single validation for multiple attributes in one line.
    -> By default, Rails provides standard error messages, but we can customize them using
       ':message'.
    

    ## 2.1 acceptance

        -> The acceptance validation in Rails is used to ensure that a checkbox was checked before
           submitting a form. 
        -> This is commonly used for
            #>Terms of Service agreements
            #>Privacy policies
            #>Consent confirmations
        
        ``` class Person < ApplicationRecord
                validates :terms_of_service, acceptance: true
            end```
        
        -> In this Rails checks whether the user checked the checkbox before allowing the form to
           be saved.
        -> If ':terms_of_service' is checked then validation pass
        -> If ':terms_of_service' is unchecked then validation fails

        ``` class Person < ApplicationRecord
                validates :terms_of_service, acceptance: { message: "must be abided" }
            end```
        
        -> In this we can pass a custom message via the 'message:' 


        ``` class Person < ApplicationRecord
                validates :terms_of_service, acceptance: { accept: "yes" }
                validates :eula, acceptance: { accept: ["TRUE", "accepted"] }
            end```
        
        -> The ':terms_of_service' checkbox must return 'yes' for validation to pass
        -> The 'eula; checkbox must return either 'TRUE' or 'accepted'

    

    ## 2.2 confirmation
        
        -> The confirmation validation in Rails is used when you need two fields to have the same
           value, such as:
        -> Password & Password Confirmation
        -> Email & Email Confirmation

        ``` class Person < ApplicationRecord
                validates :email, confirmation: true
            end```
        
        -> When you add 'validates :email, confirmation: true', Rails automatically expects an
           additional virtual field named 'email_confirmation'. 
        -> The two fields must match for validation to pass.
        -> If the user enters different values in these two fields, validation fails.
        -> If 'email_confirmation' is not provided, the validation does not run.

        ``` class Person < ApplicationRecord
                validates :email, confirmation: true
                validates :email_confirmation, presence: true
            end```
        
        -> Now, if 'email_confirmation' is left blank, it fails validation.


        ``` class Person < ApplicationRecord
                validates :email, confirmation: true
                validates :email_confirmation, presence: true, if: :email_changed?
            end```
        
        -> The 'if: :email_changed?' condition means:
            -> The validation only runs when the email field is modified.
            -> If the email hasn't changed, Rails won't require an email_confirmation every time
               the record is saved.
    

    ## 2.3 comparison

        ``` class Promotion < ApplicationRecord
                validates :end_date, comparison: { greater_than: :start_date }
            end```
        
        -> It compares two attributes 'end_date' and 'start_date' of the 'Promotion' model.
        -> It ensures that 'end_date' is greater than (>) 'start_date'.
        -> If 'end_date' is earlier than or the same as 'start_date', validation fails.

        #> ':greater_than'
        //--> validates :end_date, comparison: { greater_than: :start_date }
        
        -> Ensures end_date is strictly greater than 'start_date'
        -> Default error message: "must be greater than %{count}".

        #> ':greater_than_or_equal_to'

        -> Ensures value is greater than or equal to (>=) the given value.
        -> Default error message: "must be greater than or equal to %{count}".

        #> ':equal_to'

        -> Ensures value is equal to (==) the given value.
        -> Default error message: "must be equal to %{count}".

        #> ':less_than'

        -> Ensures value is less than (<) to the given value.
        -> Default error message: "must be less than %{count}".

        #> ':less_than_or_equal_to'

        -> Ensures value is less than or equal to (<=) the given value.
        -> Default error message: "must be less than or equal to %{count}".

        #> ':other_than'

        -> Ensures the value must be other than the supplied value
        -> Default error message: "must be other than %{count}".

    

    ## 2.4 format

        -> The 'format' validation in Rails ensures that an attribute's value follows a specific
           pattern by matching a regular expression (RegExp). 
        -> It uses the ':with' option to enforce a pattern and the ':without' option to prevent a
           pattern.
        
        ``` class Product < ApplicationRecord
                validates :legacy_code, format: { with: /\A[a-zA-Z]+\z/,
                    message: "only allows letters" }
            end```
        
        ->  "validates :legacy_code " This applies validation to the legacy_code attribute.
        -> "format: { with: /\A[a-zA-Z]+\z/ }" = This enforces that legacy_code must contain only
           letters (A-Z, a-z).
        -> message: "only allows letters" = Custom error message if validation fails.
        -> '\A' and '\z' → These ensure that the entire string is checked.

    
    ## 2.5 inclusion

        -> The inclusion validation ensures that an attribute's value is part of a predefined set.
        -> If the value is not in the specified set, Rails will mark the record as invalid.

        ``` class Coffee < ApplicationRecord
                validates :size, inclusion: { in: %w(small medium large),
                message: "%{value} is not a valid size" }
            end```
        
        -> The size attribute must be one of "small", "medium", or "large".
        -> If a different value is provided, Rails will show an error message.
        -> The error message includes %{value}, which dynamically inserts the invalid input.


    ## 2.6 exclusion

        -> The 'exclusion' validation in Rails ensures that an attribute does NOT contain specific
           values. 
        -> It’s useful when we want to prevent users from using reserved words, restricted terms,
           or certain invalid inputs.
        
        ```
        class Account < ApplicationRecord
            validates :subdomain, exclusion: { in: %w(www us ca jp),
                message: "%{value} is reserved." }
        end
        ```

        -> ':subdomain' field must NOT be one of "www", "us", "ca", or "jp".
        -> If the user tries to save an Account with subdomain: "www", it fails validation.
        -> The error message "www is reserved." will be shown.

    
    ## 2.7 length

        -> The length validator in Rails ensures that an attribute has a specific number of
           characters. 
        -> It provides several options for setting the length constraints.

        ```
        class Person < ApplicationRecord
            validates :name, length: { minimum: 2 }
            validates :bio, length: { maximum: 500 }
            validates :password, length: { in: 6..20 }
            validates :registration_number, length: { is: 6 }
        end
        ```

        -> ':minimum' – Ensures the value has at least a certain number of characters.
        -> ':maximum' – Ensures the value does not exceed a certain number of characters.
        -> ':in' (or :within) – Restricts the value to a specific range.
        -> ':is' – Requires the value to have exactly the given length.

        -> we can customize these messages using the ':wrong_length', ':too_long', and 
           ':too_short' options
        

        ```
        class Person < ApplicationRecord
            validates :bio, length: { maximum: 1000,
            too_long: "%{count} characters is the maximum allowed" }
        end
        ```

        -> Here, %{count} is replaced with the actual number


    ## 2.8 numericality

        -> This validation ensures that an attribute contains only numeric values. 
        -> It applies to both integers and floating-point numbers.

        #> When to Use 'numericality'?
        -> Validating price, age, scores, or percentages
        -> Ensuring integer values for things like IDs
        -> Restricting input to a specific range (e.g., 18-60 years old)
        -> Checking for even/odd numbers

        ```
        class Player < ApplicationRecord
            validates :points, numericality: true
            validates :games_played, numericality: { only_integer: true }
        end
        ```
        -> Ensures that points must be a number (either an integer or a decimal).
        -> If a non-numeric value is entered, Rails will reject it.

    
    ## 2.9 presence

        -> The 'presence' validation ensures that a specified attribute must not be empty before
           saving a record. 
        -> It prevents saving records with missing or blank values.

        ```
        class Person < ApplicationRecord
            validates :name, :login, :email, presence: true
        end
        ```

        -> Ensures 'name', 'login', and 'email' must be present before saving.
        -> It uses 'Object#blank?', meaning:
            -> nil is not allowed
            -> An empty string ("") is not allowed
            -> A string with only whitespace (" ") is also not allowed
        
        -> Presence Validation for Associations
        ```
        class Supplier < ApplicationRecord
            has_one :account
            validates :account, presence: true
        end
        ```
        -> Ensures that a Supplier must have an associated Account before saving.
        -> This does not check if the foreign key 'account_id' is present. Instead, it checks if
           the Account object itself exists.

        ```
        class Order < ApplicationRecord
          has_many :line_items, inverse_of: :order
        end
        ```

        -> It ensures that when an Order has 'line_items', it correctly tracks the 'parent-child'
           relationship.
        ->This is important when validating associated records.

        -> By default, false.blank? returns true
        -> If we validate presence is true on a boolean column, false might be treated as blank and
           rejected.
        
        ```validates :boolean_field_name, inclusion: [true, false]```

        -> Ensures the value must be either true or false (not nil).

        ```validates :boolean_field_name, exclusion: [nil]```

        -> Ensures the value is not nil, meaning it must be either true or false.

    
    ## 2.10 absence

        -> The 'absence' validation ensures that a specified attribute is not present in a model. 
        -> It uses Ruby’s present? method to check if the value is nil or an empty string.

        ```
        class Person < ApplicationRecord
            validates :name, :login, :email, absence: true
        end
        ``` 
        -> This ensures that name, login, and email must be blank when saving a Person record.
        -> If any of these fields contain a value, an error is raised 
           "Name must be blank," "Login must be blank," etc.
        
        -> Validating Absence of an Association
        
        ```
        class LineItem < ApplicationRecord
            belongs_to :order
            validates :order, absence: true
        end
        ```

        -> This ensures that a 'LineItem' should not be associated with any Order.
        -> However, belongs_to :order means there is an order_id foreign key in line_items.
        -> The validation does not check order_id, but rather the associated object itself (order).
        -> If order is present, an error is raised.

        -> Handling has_many Associations

        ```
        class Order < ApplicationRecord
            has_many :line_items, inverse_of: :order
        end
        ```

        -> 'inverse_of: :order' helps Rails understand the bidirectional relationship between
           Order and LineItem.
        -> Without 'inverse_of', Rails might not correctly recognize whether a LineItem exists
           in memory when validating.
        
    
    ## 2.11 uniqueness

        -> The 'uniqueness' validation in Rails ensures that an attribute's value is not duplicated
           in the database. 
        -> It runs an SQL query to check if any existing record has the same value before saving 
           the object.
        
        ```
        class Account < ApplicationRecord
            validates :email, uniqueness: true
        end
        ```

        -> Ensures that no two Account records have the same email.
        -> Error Message: "Email has already been taken"
        
        ```
        class Holiday < ApplicationRecord
            validates :name, uniqueness: { scope: :year, message: "should happen once per year" }
        end
        ```
        -> Allows a holiday name to be reused but only once per year.
        -> Custom Message: "Name should happen once per year"

        ```
        class User < ApplicationRecord
            validates :username, uniqueness: { conditions: -> { where(active: true) } }
        end
        ```

        -> Only checks uniqueness for active users
        

    ## 2.12 validates_associated

        -> 'validates_associated' is a validation helper in Rails that ensures associated records
           are valid before saving the parent record. 
        -> It is useful when we have models that depend on each other and we want to make sure
           all associated records meet validation requirements before saving the parent.
        
        ```
        class Library < ApplicationRecord
            has_many :books
            validates_associated :books
        end
        ```

        -> When we try to save a Library, Rails will also validate all the associated Book
           records.
        -> If any Book fails its validations, the Library will not be saved.
        -> The default error message will be "is invalid" if an associated record fails validation.
        -> Each associated object will store its own error messages, but they won’t automatically
           be added to the Library errors.
        

    ## 2.13 validates_each

        -> The 'validates_each' method in Rails is used for custom attribute validation. 
        -> Unlike built-in validation helpers, 'validates_each' allows you to define custom logic
           in a block.
        -> validates_each takes one or more attributes (:name, :surname in this case).
        -> It iterates over each attribute and applies the custom validation logic inside the
           block.
        -> If the validation fails, an error message is added to record.errors, making the object
           invalid.
        

        ```
        class Person < ApplicationRecord
            validates_each :name, :surname do |record, attr, value|
                record.errors.add(attr, "must start with upper case") if /\A[[:lower:]]/.match?(value)
            end
        end
        ```

        -> 'validates_each' ':name', ':surname' = Applies validation to both name and surname.
        -> 'record' = The current Person object.
        -> 'attr' = The attribute being validated (:name or :surname).
        -> 'value' = The actual value of the attribute.
        -> 'Regex /\A[[:lower:]]/' = Checks if the first character is lowercase.
        -> If lowercase, add an error = "must start with upper case".

    
    ## 2.14 validates_with

        -> The validates_with helper in Rails delegates validation to a separate class, making
           complex validations reusable and keeping the model cleaner.
        
        #> Basic custom validator
        
        ```
        class GoodnessValidator < ActiveModel::Validator
            def validate(record)
                if record.first_name == "Evil"
                    record.errors.add :base, "This person is evil"
                end
            end
        end

        class Person < ApplicationRecord
            validates_with GoodnessValidator
        end
        ```

        -> We define a validator class 'GoodnessValidator'
        -> The class inherits from 'ActiveModel::Validator'.
        -> It implements the validate(record) method.
        -> If 'record.first_name' is "Evil", an error is added to 'record.errors[:base]', 
           indicating a -> general record error.
        -> We use the validator inside the Person model
        -> 'validates_with GoodnessValidator' tells Rails to run 'GoodnessValidator' whenever a
           Person -> object is validated.
        
        #> we can use multipal validators
        ```
        class Person < ApplicationRecord
            validates_with MyValidator, MyOtherValidator, on: :create
        end
        ```

        -> 'on: :create' means the validation runs only when creating a new record, not on updates.

        #> passing outputs to validators
        ```
        class GoodnessValidator < ActiveModel::Validator
            def validate(record)
                if options[:fields].any? { |field| record.send(field) == "Evil" }
                    record.errors.add :base, "This person is evil"
                end
            end
        end

        class Person < ApplicationRecord
            validates_with GoodnessValidator, fields: [:first_name, :last_name]
        end
        ```

        -> Here, the 'fields: [:first_name, :last_name]' option allows the validator to check
           multiple fields.


        #> Avoiding Instance Variables in Validators

        ```
        class Person < ApplicationRecord
            validate do |person|
                GoodnessValidator.new(person).validate
            end
        end

        class GoodnessValidator
            def initialize(person)
                @person = person
            end

            def validate
                if some_complex_condition?
                    @person.errors.add :base, "This person is evil"
                end
            end

            private

            def some_complex_condition?
                # Some logic here
            end
        end
        ```

        -> Here, we create a new validator instance each time, making it safe to use instance
           variables.
        

        -> validates_with allows custom validations using separate classes.
        -> The validator class must define a validate(record) method.
        -> Errors can be added to specific attributes or the whole record (:base).
        -> We can pass options to make validators reusable.
        -> Avoid instance variables in validators unless using a new instance for each validation.
        
