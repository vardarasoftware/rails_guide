###### */*/*/* Active Model Basics */*/*/*/*

    -> Active Model is a library in Rails that provides functionalities similar to Active Record
       but without requiring a database. 
    -> It allows plain Ruby objects to behave like models, making them compatible with Rails 
       helpers and features like validations, callbacks, and serialization.


# 1 What is Active Model? */*/*/*/*


  -> Active Record: 
    -> An ORM (Object-Relational Mapper) that connects Ruby objects to database
       tables. 
    -> It provides methods to create, read, update, and delete records while also offering
       features like validations, callbacks, and translations.

  -> Active Model: 
    -> A lightweight alternative to Active Record that provides similar functionalities
       without requiring a database. 
    -> It is useful when you need a model-like structure but don’t want to persist data in a 
       database.
    
  -> Use case for active model:
    -> Creating form objects that handle user input but don’t need to be stored in the
       database.
    -> Implementing API request/response objects that follow model conventions.
    -> Creating custom ORMs for working with non-SQL databases or external data sources.
    

  ## 1.1 API -----

    -> 'ActiveModel::API' is a module that allows plain Ruby classes to work seamlessly with
       Action Pack and Action View. 
    -> By including this module, a class gets functionalities similar to Active Record models,
       making it easier to use with Rails forms, views, and helpers—without requiring a database.

    -> When a class includes 'ActiveModel::API', it automatically gains access to multiple
       Active Model modules, such as:

       -> Attribute Assignment
       -> Conversion
       -> Naming
       -> Translation
       -> Validations
      
    ```
    class EmailContact
      include ActiveModel::API

      attr_accessor :name, :email, :message
      validates :name, :email, :message, presence: true

      def deliver
        if valid?
          # Deliver email
        end
      end
    end
    ```



    -> Since ActiveModel::API makes objects behave like models, you can use them in Rails views
       with form_with, render, and other helpers.
    
    ```
    <%= form_with model: EmailContact.new do |form| %>
      <%= form.text_field :name %>
    <% end %>
    ```

    -> Generated HTML:
    ```
    <form action="/email_contacts" method="post">
      <input type="text" name="email_contact[name]" id="email_contact_name">
    </form>
    ```

    -> Even though EmailContact is not backed by a database, Rails treats it like a model, 
       making form handling straightforward.
      
    -> You can also use render to display a partial for an ActiveModel::API object:
    ```
    <%= render @email_contact %>
    ```
    -> This allows you to structure your views like you would with regular Active Record models.

  
  ## 1.2 Model -----

    -> ActiveModel::Model is a module in Rails that allows plain Ruby classes to behave like
       Active Record models without requiring a database. 
    -> It includes ActiveModel::API and provides additional functionalities for working with Rails
       controllers, views, and helpers.
    -> This is the recommended approach for creating model-like classes in Rails when you don’t
       need database persistence.

    -> Creating a person model:

    ```
    class Person
      include ActiveModel::Model

      attr_accessor :name, :age
    end
    ```

    -> Now, let's test the Person class in Rails Console:
    ```
    irb> person = Person.new(name: 'bob', age: '18')
    irb> person.name # => "bob"
    irb> person.age  # => "18"
    ```

    -> Unlike Active Record models, this class does not persist data to a database. 
    -> However, it acts like a model, making it useful for form objects, service objects, and API
       request handling.
    
  
  ## 1.3 Attributes ----

    -> ActiveModel::Attributes allows you to define attributes with data types, default values,
       and type casting on plain Ruby objects—just like Active Record does.
    
    -> This is useful when:
      -> You want Active Record-like behavior without a database.
      -> You need type casting
      -> You want default values for attributes.


    ```
    class Person
      include ActiveModel::Attributes

      attribute :name, :string
      attribute :date_of_birth, :date
      attribute :active, :boolean, default: true
    end
    ```

    -> attribute :name, :string → Treats name as a string.
    -> attribute :date_of_birth, :date → Converts input into a Date object.
    -> attribute :active, :boolean, default: true → Sets active to true by default and converts
       values like 0 or "false" to false.
    
    -> Now, let's test the Person class in Rails Console:
    ```
    irb> person = Person.new

    irb> person.name = "Jane"
    irb> person.name
    => "Jane"

    # Casts the string to a date set by the attribute
    irb> person.date_of_birth = "2020-01-01"
    irb> person.date_of_birth
    => Wed, 01 Jan 2020
    irb> person.date_of_birth.class
    => Date

    # Uses the default value set by the attribute
    irb> person.active
    => true

    # Casts the integer to a boolean set by the attribute
    irb> person.active = 0
    irb> person.active
    => false
    ```

  
    ## 1.3.1 Method: attribute_names

      -> The attribute_names method returns an array of attribute names

      ```
      irb> Person.attribute_names
      => ["name", "date_of_birth", "active"]
      ```

    
    ## 1.3.2 Method: attributes

      -> The attributes method returns a hash of all the attributes and their values
      
      ```
      irb> person.attributes
      => {"name" => "Jane", "date_of_birth" => Wed, 01 Jan 2020, "active" => false}
      ```

  
  ## 1.4 Attribute Assignment ----

    -> ActiveModel::AttributeAssignment allows you to set an object's attributes by passing in a
       hash of attributes with keys matching the attribute names. 
    -> This is useful when you want to set multiple attributes at once.

    ```
    class Person
      include ActiveModel::AttributeAssignment

      attr_accessor :name, :date_of_birth, :active
    end
    ```

    -> include ActiveModel::AttributeAssignment → Enables batch assignment of attributes.
    -> attr_accessor → Defines getters and setters for attributes.

    -> now let's test in rails console:

    ```
    irb> person = Person.new

    # Set multiple attributes at once
    irb> person.assign_attributes(name: "John", date_of_birth: "1998-01-01", active: false)

    irb> person.name
    => "John"
    irb> person.date_of_birth
    => Thu, 01 Jan 1998
    irb> person.active
    => false
    ```

    -> Instead of setting each attribute separately (person.name = "John"), assign_attributes does
       it all in one step.
    
    -> By default, Rails blocks mass assignment from unpermitted parameters for security reasons.

    ```
    irb> person = Person.new

    # Using strong parameters checks, build a hash of attributes similar to params from a request
    irb> params = ActionController::Parameters.new(name: "John")
    => #<ActionController::Parameters {"name" => "John"} permitted: false>

    irb> person.assign_attributes(params)
    => # Raises ActiveModel::ForbiddenAttributesError
    irb> person.name
    => nil

    # Permit the attributes we want to allow assignment
    irb> permitted_params = params.permit(:name)
    => #<ActionController::Parameters {"name" => "John"} permitted: true>

    irb> person.assign_attributes(permitted_params)
    irb> person.name
    => "John"
    ```

    -> This ensures only allowed attributes are assigned.

    ### 1.4.1 Method alias: attributes=

      -> Instead of assign_attributes, you can use attributes= for better readability.

      ```
      irb> person = Person.new

      irb> person.attributes = { name: "John", date_of_birth: "1998-01-01", active: false }

      irb> person.name
      => "John"
      irb> person.date_of_birth
      => "1998-01-01"
      ```

      -> attributes = {...} is the same as assign_attributes({...}) but shorter and more readable.



  ## 1.5 Attribute Methods -----

    -> ActiveModel::AttributeMethods allows you to dynamically define methods for attributes in
       your model. 
    -> This is useful for simplifying attribute access, adding custom behavior, and creating 
       aliases for attributes.

    ```
    class Person
      include ActiveModel::AttributeMethods

      attribute_method_affix prefix: "reset_", suffix: "_to_default!"
      attribute_method_prefix "first_", "last_"
      attribute_method_suffix "_short?"

      define_attribute_methods "name"

      attr_accessor :name

      private
        # Attribute method call for 'first_name'
        def first_attribute(attribute)
          public_send(attribute).split.first
        end

        # Attribute method call for 'last_name'
        def last_attribute(attribute)
          public_send(attribute).split.last
        end

        # Attribute method call for 'name_short?'
        def attribute_short?(attribute)
          public_send(attribute).length < 5
        end

        # Attribute method call 'reset_name_to_default!'
        def reset_attribute_to_default!(attribute)
          public_send("#{attribute}=", "Default Name")
        end
    end
    ```

    -> now we can test it in rails console:

    ```
    irb> person = Person.new
    irb> person.name = "Jane Doe"

    irb> person.first_name
    => "Jane"
    irb> person.last_name
    => "Doe"

    irb> person.name_short?
    => false

    irb> person.reset_name_to_default!
    => "Default Name"
    ```

    -> first_name → Extracts first word ("Jane")
    -> last_name → Extracts last word ("Doe")
    -> name_short? → Checks if "Jane Doe" has less than 5 characters (false)
    -> reset_name_to_default! → Resets the name to "Default Name"
    -> If you call a method not defined by define_attribute_methods, a NoMethodError will be
       raised.
    

  
    ### 1.5.1 Method: alias_attribute

      -> Sometimes, an attribute name may not be user-friendly. 
      -> alias_attribute allows you to define a more meaningful alias.

      ```
      class Person
        include ActiveModel::AttributeMethods

        attribute_method_suffix "_short?"
        define_attribute_methods :name

        attr_accessor :name

        alias_attribute :full_name, :name

        private
          def attribute_short?(attribute)
            public_send(attribute).length < 5
          end
      end
      ```

      -> now we can test it in rails console:
      ```
      irb> person = Person.new
      irb> person.name = "Joe Doe"
      irb> person.name
      => "Joe Doe"

      # `full_name` is the alias for `name`, and returns the same value
      irb> person.full_name
      => "Joe Doe"
      irb> person.name_short?
      => false

      # `full_name_short?` is the alias for `name_short?`, and returns the same value
      irb> person.full_name_short?
      => false
      ```

      -> full_name → Works the same as name
      -> full_name_short? → Works the same as name_short?


  ## 1.6 Callbacks ----

    -> ActiveModel::Callbacks allows plain Ruby objects to behave like ActiveRecord models by
       adding lifecycle callbacks. 
    -> These callbacks let you execute specific logic before, after, or around an event.

    -> Basic Steps to Use Callbacks
      -> Extend ActiveModel::Callbacks in the class.
      -> Use define_model_callbacks to declare the event
      -> Use callback methods like before_update, after_update, around_update.
      -> Call run_callbacks inside the method to trigger the callback chain.

    ```
    class Person
      extend ActiveModel::Callbacks

      define_model_callbacks :update

      before_update :reset_me
      after_update :finalize_me
      around_update :log_me

      # `define_model_callbacks` method containing `run_callbacks` which runs the callback(s) for the given event
      def update
        run_callbacks(:update) do
          puts "update method called"
        end
      end

      private
        # When update is called on an object, then this method is called by `before_update` callback
        def reset_me
          puts "reset_me method: called before the update method"
        end

        # When update is called on an object, then this method is called by `after_update` callback
        def finalize_me
          puts "finalize_me method: called after the update method"
        end

        # When update is called on an object, then this method is called by `around_update` callback
        def log_me
          puts "log_me method: called around the update method"
          yield
          puts "log_me method: block successfully called"
        end
    end
    ```

    -> Execution order:
    ```
    person = Person.new
    person.update
    ```

    -> Output:
    ```
    reset_me method: called before the update method
    log_me method: called around the update method
    update method called
    log_me method: block successfully called
    finalize_me method: called after the update method
    ```

    -> before_update → reset_me runs before update.
    -> around_update → log_me runs before and after update (calls yield).
    -> Main update method runs.
    -> around_update resumes after yield.
    -> after_update → finalize_me runs after update.

    -> If you forget to call yield inside an around callback, the main method will not execute.


    ### 1.6.1 Defining Specific Callbacks

      -> Instead of adding all three callback types (before, after, around), you can limit them.

      ```
      define_model_callbacks :create, only: :after
      define_model_callbacks :update, only: :before
      define_model_callbacks :destroy, only: :around
      ```

      -> Generated Callbacks: before_update, after_update and around_destroy 

    
    ### 1.6.2 Defining Callbacks with a Class

      -> Instead of defining callbacks inside the model, you can use a separate class.

      ```
      class Person
        extend ActiveModel::Callbacks

        define_model_callbacks :create
        before_create PersonCallbacks
      end

      class PersonCallbacks
        def self.before_create(obj)
          # `obj` is the Person instance that the callback is being called on
        end
      end
      ```
      -> When Person.new.create is called, the PersonCallbacks.before_create method runs.

    

    ### 1.6.3 Aborting Callbacks

      -> If we need to stop execution of the method when a certain condition is met, 
         use throw :abort.
      
      ```
      class Person
      extend ActiveModel::Callbacks

      define_model_callbacks :update

      before_update :reset_me
      after_update :finalize_me
      around_update :log_me

      def update
        run_callbacks(:update) do
          puts "update method called"
        end
      end

      private
        def reset_me
          puts "reset_me method: called before the update method"
          throw :abort
          puts "reset_me method: some code after abort"
        end

        def finalize_me
          puts "finalize_me method: called after the update method"
        end

        def log_me
          puts "log_me method: called around the update method"
          yield
          puts "log_me method: block successfully called"
        end
    end
    ```

    -> Execution order:
    ```
    person = Person.new
    person.update
    ```

    -> output:
    ```
    reset_me method: called before the update method
    => false
    ```


    -> reset_me ran.
    -> throw :abort stopped execution.
    -> update never ran.
    -> No further callbacks were executed.

  
  ## 1.7 Conversion ---

    -> ActiveModel::Conversion provides methods to convert objects into different forms, which is useful for things like URLs, form fields, and partial rendering in Rails.

    -> This module adds four key methods:
      -> to_model → Returns the model object itself.
      -> to_key → Returns an array of key attributes (like id).
      -> to_param → Returns a string key for use in URLs.
      -> to_partial_path → Returns a path string for rendering partials.
    

    ```
    class Person
      include ActiveModel::Conversion
      attr_accessor :id

      def initialize(id)
        @id = id
      end

      def persisted?
        id.present?
      end
    end
    ```

    -> persisted? returns true if the object has an id (meaning it’s saved).
    -> If id is nil, the object is considered new/unsave


    ### 1.7.1 to_model

      -> This method returns the object itself.
      -> It's mainly used in Rails forms to ensure an object behaves like a model.

      ```
      irb> person = Person.new(1)
      irb> person.to_model == person
      => true
      ```

      -> If a class does not act like a standard model, to_model can return a proxy object that
         wraps it.

      ```
      class Person
        def to_model
          # A proxy object that wraps your object with Active Model compliant methods.
          PersonModel.new(self)
        end
      end
      ```

    
    ### 1.7.2 to_key 

      -> Returns an array of key attributes (usually id).
      -> If the object has an id, it returns [id].
      -> If the object is new (id=nil), it returns nil.

      ```
      irb> person.to_key
      => [1]
      ```

      -> to_key is used in Rails form builders to track record uniqueness.


    ### 1.7.3 to_param

      -> Converts the key (id) into a string, suitable for use in URLs.
      -> If the object is persisted, it returns id.to_s.
      -> If not persisted, it returns nil.

      ```
      irb> person.to_param
      => "1"
      ```

      -> It helps generate URLs dynamically

    
    ### 1.7.4 to_partial_path

      -> Returns a string path where the object’s partial is located.
      -> Used in Rails views for rendering partials dynamically.

      ```
      irb> person.to_partial_path
      => "people/person"
      ```

      -> This allows Rails to automatically find the correct partial



  ## 1.8 Dirty ----

    -> 'ActiveModel::Dirty' helps track attribute changes in a model before saving. 
    -> It allows you to:
      -> Check if an attribute has changed
      -> See its previous and new values
      -> Undo changes
      -> Mark changes as saved
    
    -> This is useful for auditing, validation, and conditional logic in a Rails app.

    ```
    class Person
      include ActiveModel::Dirty

      attr_reader :first_name, :last_name
      define_attribute_methods :first_name, :last_name

      def initialize
        @first_name = nil
        @last_name = nil
      end

      def first_name=(value)
        first_name_will_change! unless value == @first_name
        @first_name = value
      end

      def last_name=(value)
        last_name_will_change! unless value == @last_name
        @last_name = value
      end

      def save
        # Persist data - clears dirty data and moves `changes` to `previous_changes`.
        changes_applied
      end

      def reload!
        # Clears all dirty data: current changes and previous changes.
        clear_changes_information
      end

      def rollback!
        # Restores all previous data of the provided attributes.
        restore_attributes
      end
    end
    ```

    -> define_attribute_methods enables change tracking for first_name and last_name.
    -> Attributes must be manually defined with getter methods (attr_reader).
    -> first_name_will_change! marks first_name as changed before updating its value.
    -> This ensures Rails tracks modifications.
    -> changes_applied clears dirty changes and moves them to previous_changes.
    -> This means no attributes will be considered changed after saving.
    -> clear_changes_information: Clears all change tracking.
    -> restore_attributes: Reverts attributes to their last saved values.


    ### 1.8.1 Querying an Object Directly for its List of All Changed Attributes

      ```
      irb> person = Person.new

      # A newly instantiated `Person` object is unchanged:
      irb> person.changed?
      => false

      irb> person.first_name = "Jane Doe"
      irb> person.first_name
      => "Jane Doe"
      ```
      -> changed? returns true if any attribute has unsaved changes.

      ```
      irb> person.changed?
      => true
      ```
      -> changed returns an array of modified attributes.


      ```
      irb> person.changed_attributes
      => {"first_name" => nil}
      ```
      -> changed_attributes shows a hash of changed attributes with their original values.


      ```
      irb> person.changes
      => {"first_name" => [nil, "Jane Doe"]}
      ```
      -> changes returns a hash showing old and new values.


      ```
      irb> person.previous_changes
      => {}

      irb> person.save
      irb> person.previous_changes
      => {"first_name" => [nil, "Jane Doe"]}
      ```
      -> previous_changes tracks all changes after saving.


    
    ### 1.8.2 Attribute-based Accessor Methods

      ```
      irb> person = Person.new

      irb> person.changed?
      => false

      irb> person.first_name = "John Doe"
      irb> person.first_name
      => "John Doe"
      ```



      ```
      irb> person.first_name_changed?
      => true
      ```
      -> Returns true if first_name changed.


      ```
      irb> person.first_name_was
      => nil
      ```
      -> first_name_was returns the old value before modification.


      ```
      person.first_name_change
      # => [nil, "Jane Doe"]

      person.last_name_change
      # => nil
      ```
      -> Returns [old_value, new_value] for changed attributes.
      -> Returns nil if the attribute was not changed.


      ```
      irb> person.first_name_previously_changed?
      => false
      irb> person.save
      irb> person.first_name_previously_changed?
      => true
      ```

      -> Tracks whether an attribute was changed before saving.


      ```
      irb> person.first_name_previous_change
      => [nil, "John Doe"]
      ```
      -> Returns [old_value, new_value] before the model was saved.



  ## 1.9 Naming ----

    -> ActiveModel::Naming provides naming conventions for models in Rails. 
    -> It helps in:
      -> Generating singular/plural model names
      -> Creating route and param keys
      -> Making model names user-friendly
    
    -> This is especially useful for form helpers, path helpers, and URL generation in Rails
       applications.
    
    -> To use it, extend the module in our class:

    ```
    class Person
      extend ActiveModel::Naming
    end
    ```

    -> This adds useful class methods to get different names for the model.


    ### 1.9.1 Customize the Name of the Model

      -> Sometimes, you want to remove namespaces from URLs and paths.

      ```
      module Person
        class Profile
          include ActiveModel::Model
        end
      end
      ```
      -> Rails generates /person/profiles instead of /profiles.
      -> Path helpers: person_profiles_path instead of profiles_path.

      -> Override model_name inside the class:
      ```
      module Person
        class Profile
          include ActiveModel::Model

          def self.model_name
            ActiveModel::Name.new(self, nil, "Profile")
          end
        end
      end
      ```

      -> model_name.name → "Profile" (removes Person::)
      -> model_name.route_key → "profiles" (shorter URL)
      -> profiles_path works instead of person_profiles_path


      -> Since we removed the namespace, we must define routes accordingly:
      ```
      Rails.application.routes.draw do
        resources :profiles
      end
      ```
      -> This ensures: profiles_path works and /profiles is the correct URL


      ```
      irb> name = ActiveModel::Name.new(Person::Profile, nil, "Profile")
      => #<ActiveModel::Name:0x000000014c5dbae0

      irb> name.singular
      => "profile"
      irb> name.singular_route_key
      => "profile"
      irb> name.route_key
      => "profiles"
      ```


  
  ## 1.10 SecurePassword ----

    -> ActiveModel::SecurePassword is a built-in module in Rails that provides secure password
       handling by encrypting passwords using bcrypt. 
    -> It helps store passwords securely and provides authentication methods.

    -> When we include ActiveModel::SecurePassword, it adds:
      -> A has_secure_password method to your model
      -> Automatic password validations
      -> Encryption of passwords using bcrypt
      -> Authentication methods
    
    -> Requirement: we must have a password_digest attribute in our model.

    ```
    class Person
      include ActiveModel::SecurePassword

      has_secure_password
      has_secure_password :recovery_password, validations: false

      attr_accessor :password_digest, :recovery_password_digest
    end
    ```

    -> has_secure_password automatically:
      -> Encrypts the password
      -> Adds password validation
      -> Provides authentication
    

    ```
    irb> person = Person.new

    # When password is blank.
    irb> person.valid?
    => false

    # When the confirmation doesn't match the password.
    irb> person.password = "aditya"
    irb> person.password_confirmation = "nomatch"
    irb> person.valid?
    => false

    # When the length of password exceeds 72.
    irb> person.password = person.password_confirmation = "a" * 100
    irb> person.valid?
    => false

    # When only password is supplied with no password_confirmation.
    irb> person.password = "aditya"
    irb> person.valid?
    => true

    # When all validations are passed.
    irb> person.password = person.password_confirmation = "aditya"
    irb> person.valid?
    => true

    irb> person.recovery_password = "42password"

    # `authenticate` is an alias for `authenticate_password`
    irb> person.authenticate("aditya")
    => #<Person> # == person
    irb> person.authenticate("notright")
    => false
    irb> person.authenticate_password("aditya")
    => #<Person> # == person
    irb> person.authenticate_password("notright")
    => false

    irb> person.authenticate_recovery_password("aditya")
    => false
    irb> person.authenticate_recovery_password("42password")
    => #<Person> # == person
    irb> person.authenticate_recovery_password("notright")
    => false

    irb> person.password_digest
    => "$2a$04$gF8RfZdoXHvyTjHhiU4ZsO.kQqV9oonYZu31PRE4hLQn3xM2qkpIy"
    irb> person.recovery_password_digest
    => "$2a$04$iOfhwahFymCs5weB3BNH/uXkTG65HR.qpW.bNhEjFP3ftli3o5DQC"
    ```

    --> Why Use ActiveModel::SecurePassword?
      -> Encryption
      -> Automatic validations
      -> Easy authentication
      -> Prevents security risks 

    

  ## 1.11 Serialization ----

    -> ActiveModel::Serialization and ActiveModel::Serializers::JSON are used to convert objects
       into hashes or JSON format. 
    -> This is useful when you need to send data in APIs or serialize objects for storage.

    -> How ActiveModel::Serialization works:
      -> Include ActiveModel::Serialization in your class.
      -> Define an attributes method, returning a hash with attribute names as strings
      -> Use serializable_hash to get a serialized version of the object.
    
    ```
    class Person
      include ActiveModel::Serialization

      attr_accessor :name, :age

      def attributes
        # Declaration of attributes that will be serialized
        { "name" => nil, "age" => nil }
      end

      def capitalized_name
        # Declared methods can be later included in the serialized hash
        name&.capitalize
      end
    end
    ```

    -> test in rails console:
    ```
    person = Person.new
    person.serializable_hash  # => {"name" => nil, "age" => nil}

    # Set attributes
    person.name = "bob"
    person.age = 22
    person.serializable_hash  # => {"name" => "bob", "age" => 22}

    # Include a method in serialization
    person.serializable_hash(methods: :capitalized_name)
    # => {"name" => "bob", "age" => 22, "capitalized_name" => "Bob"}

    # Serialize only specific attributes
    person.serializable_hash(only: :name)  # => {"name" => "bob"}

    # Exclude attributes from serialization
    person.serializable_hash(except: :name)  # => {"age" => 22}

    ```



    -> We can serialize associated objects by using include.

    ```
      class Person
        include ActiveModel::Serialization
        attr_accessor :name, :notes # Emulate has_many :notes

        def attributes
          { "name" => nil }
        end
      end

      class Note
        include ActiveModel::Serialization
        attr_accessor :title, :text

        def attributes
          { "title" => nil, "text" => nil }
        end
      end
      ```

      -> test in rails console:
      ```
      irb> note = Note.new
      irb> note.title = "Weekend Plans"
      irb> note.text = "Some text here"

      irb> person = Person.new
      irb> person.name = "Napoleon"
      irb> person.notes = [note]

      irb> person.serializable_hash
      => {"name" => "Napoleon"}

      irb> person.serializable_hash(include: { notes: { only: "title" }})
      => {"name" => "Napoleon", "notes" => [{"title" => "Weekend Plans"}]}
      ```


      ### 1.11.1 ActiveModel::Serializers::JSON

        -> nclude ActiveModel::Serializers::JSON instead of ActiveModel::Serialization.
        -> Provides as_json (returns a hash) and to_json (returns a JSON string).
        -> Allows parsing JSON back into objects with from_json.
      
        ```
        class Person
          include ActiveModel::Serializers::JSON

          attr_accessor :name

          def attributes
            { "name" => nil }
          end
        end
        ```

        -> test in rails console
        ```
        irb> person = Person.new

        # A hash representing the model with its keys as a string
        irb> person.as_json
        => {"name" => nil}

        # A JSON string representing the model
        irb> person.to_json
        => "{\"name\":null}"

        irb> person.name = "Bob"
        irb> person.as_json
        => {"name" => "Bob"}

        irb> person.to_json
        => "{\"name\":\"Bob\"}"
        ```



        -> we can convert JSON back into an object using from_json.
        -> Steps:
          -> Define an attributes= method to assign values.
          -> Use from_json to parse JSON into a Ruby object.

        ```
        class Person
          include ActiveModel::Serializers::JSON

          attr_accessor :name

          def attributes=(hash)
            hash.each do |key, value|
              public_send("#{key}=", value)
            end
          end

          def attributes
            { "name" => nil }
          end
        end
        ```


        -> test in rails console:
        ````
        irb> json = { name: "Bob" }.to_json
        => "{\"name\":\"Bob\"}"

        irb> person = Person.new

        irb> person.from_json(json)
        => #<Person:0x00000100c773f0 @name="Bob">

        irb> person.name
        => "Bob"
        ````



        --> Why Use Serialization?
          -> Easy API Responses – Convert objects into JSON for APIs.
          -> Selective Attributes – Control what gets serialized.
          -> Association Support – Serialize relationships.
          -> Bi-directional Conversion – Convert JSON back into objects.

  

  ## 1.12 Translation -----

    -> ActiveModel::Translation allows your model attributes to integrate with the Rails
       Internationalization (i18n) framework. 
    -> This means that attribute names can be automatically translated based on the current
       locale.

    -> How Translation Works:
      -> Include ActiveModel::Translation in your class.
      -> Define translations in the config/locales folder.
      -> Use human_attribute_name to get a human-readable version of an attribute.
      -> Set I18n.locale to change the language dynamically.

    ```
    class Person
      extend ActiveModel::Translation
    end
    ```

    ->  The extend keyword is used because translation methods are class methods.

    -> Rails stores translations in YAML files inside config/locales/.

    ```
    pt-BR:
      activemodel:
        attributes:
          person:
            name: "Nome"
    ```
    -> This YAML structure maps person.name to "Nome" when the locale is pt-BR.


    ```
    irb> Person.human_attribute_name("name")
    => "Name"

    irb> I18n.locale = :"pt-BR"
    => :"pt-BR"
    irb> Person.human_attribute_name("name")
    => "Nome"
    ```
    -> The human_attribute_name method returns a human-readable attribute name based on the 
       current locale.

  
  ## 1.13 Validations ----

    -> ActiveModel::Validations helps ensure data integrity and consistency in our Rails
       application by enforcing rules on attributes.
      
    ```
    class Person
      include ActiveModel::Validations

      attr_accessor :name, :email, :token

      validates :name, presence: true
      validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
      validates! :token, presence: true
    end
    ```


    -> test in rails console:
    ```
    irb> person = Person.new
    irb> person.token = "2b1f325"
    irb> person.valid?
    => false

    irb> person.name = "Jane Doe"
    irb> person.email = "me"
    irb> person.valid?
    => false

    irb> person.email = "jane.doe@gmail.com"
    irb> person.valid?
    => true

    # `token` uses validate! and will raise an exception when not set.
    irb> person.token = nil
    irb> person.valid?
    => "Token can't be blank (ActiveModel::StrictValidationFailed)"
    ```

    -> person.valid? checks if the object passes all validation rules.
    -> Since name is missing, validation fails.
    -> Now name is present, but email is invalid
    -> Now all attributes meet the validation rules, so valid? returns true.
    -> validates! raises an exception (ActiveModel::StrictValidationFailed) instead of just
       adding an error message.


    ### 1.13.1 Validation Methods and Options

      -> Validation Methods
        -> validate	--> Runs custom validation logic using a method or block.
        -> validates --> Shortcut for common validators (e.g., presence, format, length).
        -> validates! or strict: --> true	Forces validation failures to raise exceptions.
        -> validates_with -->	Uses a separate validator class for complex validations.
        -> validates_each	--> Runs a validation block for each attribute.

      
      -> Validation Options
        -> :on --> Runs validation only in specific contexts.
        -> :if --> Runs validation only if a condition is met.
        -> :unless --> Skips validation if a condition is met.
        -> :allow_nil	--> Skips validation if attribute is nil.
        -> :allow_blank	--> Skips validation if attribute is blank.
        -> :strict --> Raises an exception instead of adding an error message.
      
    
    ### 1.13.2 Errors

      -> ActiveModel automatically adds an errors method, which stores validation errors.

      ```
      irb> person = Person.new

      irb> person.email = "me"
      irb> person.valid?
      => # Raises Token can't be blank (ActiveModel::StrictValidationFailed)

      irb> person.errors.to_hash
      => {:name => ["can't be blank"], :email => ["is invalid"]}

      irb> person.errors.full_messages
      => ["Name can't be blank", "Email is invalid"]
      ```

      -> This raises an exception because token uses validates!.
      -> errors.to_hash returns a hash with all the validation failures.
      -> errors.full_messages returns human-readable error messages.




      --> 'validates' applies built-in validation rules.
      --> 'validates!' raises an exception if validation fails.
      --> You can add custom validation logic using 'validates_each' or 'validates_with'.
      --> Use 'valid?' to check if an object passes validation.
      --> The 'errors' object stores validation failures.



  ## 1.14 Lint Tests ---

    -> 'ActiveModel::Lint::Tests' is a built-in test suite in Rails that helps us check whether a
       custom object correctly follows the Active Model API. 
    -> It ensures that our model behaves like an ActiveModel-compliant object.

    -> Why Use Lint::Tests?
      -> If we create custom models, they should behave like standard Active Model objects.
      -> It does not check if our model logic is correct, only if the required methods exist.
      -> Helps us catch missing methods that Rails expects, like:
        -> to_model
        -> valid?
        -> persisted?
        -> errors
        -> new_record?
        -> destroyed?
        -> to_key
    
    ```
    class Person
      include ActiveModel::API
    end
    ```

    -> ActiveModel::API automatically includes ActiveModel::Lint::Tests-required methods.
    -> This makes the Person model behave like an ActiveModel-compatible object.


    ````
    require "test_helper"

    class PersonTest < ActiveSupport::TestCase
      include ActiveModel::Lint::Tests  # Include the Lint tests for compliance

      setup do
        @model = Person.new  # Initialize a Person instance before each test
      end
    end
    ```
    -> ActiveSupport::TestCase: Base class for Rails tests.
    -> include ActiveModel::Lint::Tests: Adds predefined compliance tests.
    -> setup do ... end: Runs before each test to initialize @model.

    -> Run the test using: "bin/rails test"

    -> Output:
    ```
    Run options: --seed 14596

    # Running:

    ......

    Finished in 0.024899s, 240.9735 runs/s, 1204.8677 assertions/s.

    6 runs, 30 assertions, 0 failures, 0 errors, 0 skips
    ```
    
    -> 6 tests ran successfully
    -> 30 assertions passed
    -> No failures, errors, or skipped tests
    -> our Person model is fully ActiveModel-compliant

    

