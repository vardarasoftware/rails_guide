# */*/*/*/*/* ---> Action Controller Overview <--- */*/*/*/*

# 1 Introduction */*/*/*
  
  -> The Action Controller is a key part of the Model-View-Controller (MVC) architecture in Rails.
  -> It acts as the C (Controller), managing the interaction between the Model (data layer) and 
     the View (user interface).

  -> How it works:
    > Request Handling
    > Intracting with models
    > Randring Views
    > Handling User Input


# 2 Creating a Controller */*/*/*/*

  -> A controller in Rails is a Ruby class that inherits from ApplicationController. 
  -> It serves as the link between the user's request and the application's response, handling
     logic before passing data to the view.
  
  
  -> How Controller Works:

  -> The Router Matches the Request to a Controller
    > When a user visits /clients/new, the Rails router identifies ClientsController as the 
      appropriate controller.
    > Rails creates an instance of ClientsController and calls the new method.

  -> Creating a Controller Class
    > A controller is simply a Ruby class that extends ApplicationController

    ```
    class ClientsController < ApplicationController
      def new
      end
    end
    ```
  
  -> Here, new is an instance method, meaning it gets called on an instance of ClientsController,
     not on the class itself.

  -> If the new method is empty, Rails automatically looks for and renders the corresponding view
     file
    ```
    app/views/clients/new.html.erb
    ```
  
  -> This means even if we don’t explicitly render anything in the new method, Rails assumes we
     want to display the new.html.erb view.
  

  -> In a real application, the new action typically initializes a new instance of a model before 
     passing it to the view

    ```
    def new
      @client = Client.new
    end
    ```

    -> Client.new creates a new, empty Client object.
    -> @client is an instance variable, meaning it can be accessed inside the corresponding view
       (new.html.erb).
    -> This allows the view to display a form where users can enter client details.



  ## 2.1 Controller Naming Convention -*-*-*-*

    -> Rails follows a naming convention to maintain consistency and make development easier. 

    -> Controllers Should Be Plural
    -> When creating a controller, Rails prefers using the plural form of the resource it manages.
    
    -> Example:
      > ClientsController (for handling multiple clients)
      > ClientController (not recommended)
      > SiteAdminsController (for multiple site admins)
      > SiteAdminController (not recommended)
    
    -> This convention allows route generators like resources :clients to work automatically
       without extra configurations.


    -> Models Should Be Singular
    -> While controllers are plural, models should be singular:
      > Client (Model) → Clients (Incorrect)
      > SiteAdmin (Model) → SiteAdmins (Incorrect)
    
    -> This is because models represent a single record in the database, while controllers manage
       multiple records.
    



# 3 Parameters */*/*/*/*

  -> When a request is sent to our Rails application, data from the request is stored in the 
     params hash. 
  -> These parameters can come from:
    > Query Strings (GET Parameters) – Sent in the URL
    > Form Data (POST Parameters) – Sent in the request body

  ```
  def index
    if params[:status] == "activated"
      @clients = Client.activated  # Fetch activated clients
    else
      @clients = Client.inactivated  # Fetch inactive clients
    end
  end
  ```

  -> This allows filtering clients based on their status.

  -> When a user submits a form, data is sent in the request body, not in the URL.

  ```
  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to @client
    else
      render "new"
    end
  end

  private

  def client_params
    params.require(:client).permit(:name, :email, :phone)
  end
  ```

  -> require(:client): Ensures params contains :client.
  -> permit(:name, :email, :phone): Allows only specific attributes.



  ## 3.1 Hash and Array Parameters -*-*-*-*

    -> Hash and Arry Parameters explains how Rails handles parameters (params) sent via URLs or
      form submissions. 
    -> It focuses on how arrays and hashes can be structured in parameters.

    
    //-> Handling array in params

    -> In Rails, we can send multiple values for a parameter by appending [] to the key name.

    ```
    GET /users?ids[]=1&ids[]=2&ids[]=3
    ```

    -> The resulting params in Rails will be:
    ```
    params[:ids] # => ["1", "2", "3"]
    ```

    -> The browser automatically encodes [] characters (%5b%5d).
    -> Rails automatically decodes them, so you get an array.
    -> Values in params are always strings (e.g., "1" instead of 1).


    //-> Handling Hashes in params

    -> we can structure parameters as a nested hash by using square brackets ([]) in form field
       names.
    
    ```
    <form action="/users" method="post">
      <input type="text" name="user[name]" value="Acme" />
      <input type="text" name="user[phone]" value="12345" />
      <input type="text" name="user[address][postcode]" value="12345" />
      <input type="text" name="user[address][city]" value="Carrot City" />
    </form>
    ```


    -> When this form is submitted, Rails will interpret params[:user] as:

    ```
    params[:user] = {
      "name" => "Acme",
      "phone" => "12345",
      "address" => {
        "postcode" => "12345",
        "city" => "Carrot City"
      }
    }
    ```


    -> params[:user] contains a hash with nested keys.
    -> params[:user][:address] itself is a hash ({ "postcode" => "12345", "city" => "Carrot 
       City" }).
    -> This makes handling complex data (like user profiles or settings) easier.

  

  ## 3.2 Composite Key Parameters -*-*-*-*

    -> Composite key parameters store multiple values in a single parameter using a delimiter. 
    -> Rails provides the extract_value method to split these values into an array.


    -> Consider a Books system where each book has a primary ID and a secondary ID combined into
       one parameter.

    -> Defining the Controller
    ```
    class BooksController < ApplicationController
      def show
        # Extract composite key from params[:id]
        id = params.extract_value(:id) 
        @book = Book.find(id)
      end
    end
    ```

    -> What params.extract_value(:id) Does:
      > If a request comes as /books/4_2, the :id parameter will be "4_2".
      > extract_value(:id) splits it into ["4", "2"].


    -> Defining Routes:
    ```
    get "/books/:id", to: "books#show"
    ```

    -> Now, /books/4_2 is mapped to the show action in BooksController.

  

  ## 3.3 JSON Parameters -*-*-*-*

    -> When building APIs or receiving JSON data in a Rails application, parameters are
       automatically parsed into the params hash if the request’s Content-Type is set to application/json.
    

    -> If a client (like Postman or a frontend app) sends the following JSON in a POST request:

    ```
    {
      "user": {
        "name": "acme",
        "address": "123 Carrot Street"
      }
    }
    ```

    -> Rails will automatically parse it into:
    ```
    params # => { "user" => { "name" => "acme", "address" => "123 Carrot Street" } }
    ```


    -> we can then access it in a controller:
      ```
      def create
        name = params[:user][:name] # "acme"
        address = params[:user][:address] # "123 Carrot Street"
      end
      ```

  
    ### 3.3.1 Configuring Wrap Parameters ----

      -> Rails has a feature called Wrap Parameters, which automatically adds a root key based on
         the controller name.
      

      -> Instead of sending:
        ```
        { "user": { "name": "acme", "address": "123 Carrot Street" } }
        ```

      -> We can send:
        ```
        { "name": "acme", "address": "123 Carrot Street" }
        ```

      -> Rails will automatically wrap it into:
        ```
        { "name" => "acme", "address" => "123 Carrot Street", "user" => { "name" => "acme", "address" => "123 Carrot Street" } }
        ```

      -> This makes it easier to work with JSON data inside the controller.


      -> Enabled by default, but we can turn it off in config/application.rb:

      ```
      config.action_controller.wrap_parameters_by_default = false
      ```

      -> If we only want to wrap specific controllers, add this to the controller:
      ```
      class UsersController < ApplicationController
        wrap_parameters :user, include: [:name, :address]
      end
      ```

  

  ## 3.4 Routing Parameters -*-*-*-*

    -> Routing parameters are values extracted from the URL when a request is made. 
    -> These parameters are automatically available in the params hash inside the controller.

    -> In config/routes.rb, we can define a route like this:
    ```
    get "/clients/:status", to: "clients#index", foo: "bar"
    ```

    -> :status is a dynamic segment in the URL.
    -> "foo" => "bar" is an optional static parameter.



  ## 3.5 The default_url_options Method -*-*-*-*

    -> The default_url_options method allows us to set global default parameters for URL
       generation in Rails. 
    -> This means that every time a URL is generated using url_for or path helpers, the default 
       options will be automatically included unless explicitly overridden.
    
    -> To set default URL options globally, define this method inside ApplicationController:
      ```
      class ApplicationController < ActionController::Base
        def default_url_options
          { locale: I18n.locale }  # Automatically adds the current locale to all URLs
        end
      end
      ```

    -> If I18n.locale is :en, then:
      ```
      posts_path # => "/posts?locale=en"
      clients_path # => "/clients?locale=en"
      ```

    -> If I18n.locale is :fr:
      ```
      posts_path
      ```

    
    -> Even though locale is automatically added, we can override it manually when generating URLs:

    ```
    posts_path(locale: :es) # => "/posts?locale=es"
    clients_path(locale: nil) # => "/clients"
    ```

    -> We can provide a different value (locale: :es).
    -> We can remove the parameter (locale: nil).
    





# 4 Strong Parameters */*/*/*/*

  -> Strong Parameters is a security feature in Rails that prevents mass assignment 
     vulnerabilities by requiring explicit permission before updating model attributes.
  
  -> By default, Rails does not allow mass assignment of parameters unless explicitly permitted.
  -> This prevents attackers from modifying sensitive attributes (e.g., admin: true) through form
     submissions.
  -> To prevent mass assignment issues, Rails requires explicitly permitting attributes:

    ```
    class PeopleController < ActionController::Base
      # This will raise an ActiveModel::ForbiddenAttributesError
      # because it's using mass assignment without an explicit permit.
      def create
        Person.create(params[:person])
      end

      # This will work as we are using `person_params` helper method, which has the
      # call to `expect` to allow mass assignment.
      def update
        person = Person.find(params[:id])
        person.update!(person_params)
        redirect_to person
      end

      private
        # Using a private method to encapsulate the permitted parameters is a good
        # pattern. You can use the same list for both create and update.
        def person_params
          params.expect(person: [:name, :age])
        end
    end
    ```
  
  -> params.require(:person): Ensures the person key is present in the request.
  -> If missing, Rails will return a 400 Bad Request error.
  -> .permit(:name, :age): Allows only specific attributes (name, age) to be updated.



  ## 4.1 Permitting Values -*-*-*-*

    ### 4.1.1 expect ---

      -> The expect method is a strict way to extract parameters. 
      -> It ensures the presence of a parameter and permits only the specified values. 
      -> If the key is missing or invalid, it raises an error (HTTP 400 Bad Request).

      ```
      id = params.expect(:id)
      ```

      -> Ensures :id is present.
      -> Always returns a scalar value (single value, not an array or hash).
      -> If :id is missing, it raises an error.


      ```
      user_params = params.expect(user: [:username, :password])
      user_params.has_key?(:username) # => true
      ```

      -> Ensures :user exists and contains :username and :password.
      -> If :user is missing, it raises a 400 Bad Request error.


      ```
      params.expect(log_entry: {})
      ```

      -> Allows all current and future attributes inside :log_entry.
      -> Risky! If the model structure changes, new fields could be mass-assigned unexpectedly.


    
    ### 4.1.2 permit ----

      -> The permit method allows specific parameters for mass assignment. Unlike expect, it does
         not raise an error if a key is missing.
      
      ```
      params = ActionController::Parameters.new(id: 1, admin: "true")
      => #<ActionController::Parameters {"id"=>1, "admin"=>"true"} permitted: false>
      params.permit(:id)
      => #<ActionController::Parameters {"id"=>1} permitted: true>
      params.permit(:id, :admin)
      => #<ActionController::Parameters {"id"=>1, "admin"=>"true"} permitted: true>
      ```

      -> Only allows the permitted keys.
      -> Unpermitted values are filtered out without raising an error.


      ```
      params = ActionController::Parameters.new(tags: ["rails", "parameters"])
      => #<ActionController::Parameters {"tags"=>["rails", "parameters"]} permitted: false>
      params.permit(tags: [])
      => #<ActionController::Parameters {"tags"=>["rails", "parameters"]} permitted: true>
      ```

      -> Ensures that tags contains only permitted scalar values (e.g., strings, numbers, dates).


      ```
      params = ActionController::Parameters.new(options: { darkmode: true })
      => #<ActionController::Parameters {"options"=>{"darkmode"=>true}} permitted: false>
      params.permit(options: {})
      => #<ActionController::Parameters {"options"=>#<ActionController::Parameters {"darkmode"=>true} permitted: true>} permitted: true>
      ```

      -> Allows all permitted scalars inside options.
      -> Risk: Allowing an entire hash ({}) might expose sensitive fields.


    ### 4.1.3 permit! ----

      -> The permit! method allows all parameters without any restrictions.

      ```
      params = ActionController::Parameters.new(id: 1, admin: "true")
      => #<ActionController::Parameters {"id"=>1, "admin"=>"true"} permitted: false>
      params.permit!
      => #<ActionController::Parameters {"id"=>1, "admin"=>"true"} permitted: true>
      ```

      -> All attributes are allowed.
      -> Use only when you trust the source (e.g., internal APIs).





  ## 4.2 Nested Parameters *-*-*-*-*

    -> In Rails, nested parameters are often used when dealing with complex data structures like
       arrays of objects or deeply nested hashes.
    
    -> To safely extract and permit nested parameters, we use expect or permit.

    ```
    params = ActionController::Parameters.new(
      name: "Martin",
      emails: ["me@example.com"],
      friends: [
        { name: "André", family: { name: "RubyGems" }, hobbies: ["keyboards", "card games"] },
        { name: "Kewe", family: { name: "Baroness" }, hobbies: ["video games"] },
      ]
    )
    ```

    -> name: A string (scalar value).
    -> emails: An array of strings.
    -> friends: An array of hashes, where:
      > Each friend has a name (string).
      > Each friend has a family hash (only name is allowed).
      > Each friend has a hobbies array (only strings are allowed).


    -> Extracting and Permitting Nested Parameters
    ```
    name, emails, friends = params.expect(
      :name,                 #  Permitted scalar
      emails: [],            #  Array of permitted scalars (strings)
      friends: [[            #  Array of permitted hashes (note the double brackets `[[ ]]`)
        :name,               #  Permitted scalar inside each friend object
        family: [:name],     #  Permitted nested hash (family with only `name`)
        hobbies: []          #  Array of permitted scalars inside friends
      ]]
    )
    ```

    -> Allows name as a simple string.
    -> Allows emails to be an array of strings.
    -> The double array syntax ([[ ... ]]) means friends must be an array of objects with specific
       fields.
    

  ## 4.3 Examples -*-*-*-*

    -> These examples demonstrate how to use Strong Parameters in Rails to securely permit 
       specific attributes in controller actions.

    -> Example 1: Using fetch to Handle Missing Parameters
    -> When creating a new record, the root key (like :blog) might not exist in the params. 
    -> If we try to use require(:blog), it will throw an error. Instead, fetch(:blog, {}) ensures 
       that even if :blog is missing, an empty hash {} is used, allowing the .permit(:title, 
       :author) method to work safely.

    ```
    params.fetch(:blog, {}).permit(:title, :author)
    ```

    -> If params contains { blog: { title: "My Blog", author: "John Doe" } }, it permits title 
       and author.
    -> If params does not contain :blog, fetch provides {} instead of raising an error.


    -> Example 2: Permitting Nested Attributes for Associated Records
    -> When updating associated records (e.g., an author with books), Rails requires special 
       handling. 
    -> The accepts_nested_attributes_for method in the model allows updating or destroying 
       associated records based on id and _destroy.

    ```
    params.expect(author: [ :name, books_attributes: [[ :title, :id, :_destroy ]] ])
    ````

    -> This allows:
      > :name for the author
      > :title, :id, and :_destroy for nested books
      > The _destroy attribute is used to mark a record for deletion.


    -> Example 3: Handling Hashes with Numeric Keys in Nested Attributes
    -> When dealing with has_many associations, nested attributes might use integer keys instead 
       of arrays.


    ```
    {
      "book" => {
        "title" => "Some Book",
        "chapters_attributes" => {
          "1" => { "title" => "First Chapter" },
          "2" => { "title" => "Second Chapter" }
        }
      }
    }


    -> The strong parameters must be defined as:

    ```
    params.expect(book: [ :title, chapters_attributes: [[ :title ]] ])
    ````

    -> :title is permitted for the book.
    -> chapters_attributes allows multiple chapters, each having a :title.


    
    -> Example 4: Permitting a Hash with Arbitrary Data
    -> Sometimes, you need to allow a hash with unknown keys (e.g., dynamic metadata or settings).

    ```
    def product_params
      params.expect(product: [ :name, data: {} ])
    end
    ```

    -> :name is permitted for the product.
    -> data: {} allows any key-value pairs inside the data hash.

    -> This is useful when you don’t know in advance what keys will be inside data, but 
       we still want to permit the whole hash.



# 5 Cookies */*/*/*/*

  -> Cookies are small pieces of data stored in a user’s browser by a web server. 
  -> They help web applications remember information across different requests, such as user 
     preferences, login sessions, or form data.
  -> Rails provides a simple way to work with cookies using the cookies method, which behaves 
     like a hash.
  
    ```
    class CommentsController < ApplicationController
      def new
        # Auto-fill the commenter's name if it has been stored in a cookie
        @comment = Comment.new(author: cookies[:commenter_name])
      end

      def create
        @comment = Comment.new(comment_params)
        if @comment.save
          if params[:remember_name]
            # Save the commenter's name in a cookie.
            cookies[:commenter_name] = @comment.author
          else
            # Delete cookie for the commenter's name, if any.
            cookies.delete(:commenter_name)
          end
          redirect_to @comment.article
        else
          render action: "new"
        end
      end
    end
    ```
  
  -> new action:
    > If the commenter_name cookie exists, it pre-fills the name field.

  -> create action:
    > If the user checks "Remember my name," the name is saved in a cookie.
    > Otherwise, the cookie is deleted.


  -> By default, a cookie disappears when the user closes their browser (a session cookie). However, you can set an expiration time.

  -> Set a cookie to expire in 1 hour:
    
    ```
    cookies[:login] = { value: "XJ-122", expires: 1.hour }
    ```

  -> Delete a cookie properly:
    ```
    cookies.delete(:login)  # This removes the cookie
    ```
  
  -> Setting a cookie to nil does NOT delete it. we must use cookies.delete(:key).


  -> Permanent Cookies (Never Expire)
    > To create a cookie that lasts 20 years, use the permanent method:

    ```
    cookies.permanent[:locale] = "fr"
    ```

  -> This is useful for storing user preferences like language settings.



  ## 5.1 Encrypted and Signed Cookies -*-*-*-*

    -> Since cookies are stored on the client’s browser, they can be modified by the user. 
    -> This makes them unsafe for storing sensitive data like user IDs, expiration dates, or
       authentication tokens.

    -> Rails provides two special types of cookies to improve security:

      > Signed Cookies → Prevent tampering but data is still visible.
      > Encrypted Cookies → Prevent tampering and hide the data.

    
    ->> Single Cookies -> Signed cookies append a cryptographic signature to the data. 
                          This ensures that the data cannot be modified by the user. 
                          However, the data is still readable in the browser.
    
    ->> Encrypted Cookies -> Encrypted cookies both sign and encrypt the data, meaning:
                             Users cannot modify them and Users cannot read their contents.
                          

    -> Using Signed & Encrypted Cookies
    ```
    class CookiesController < ApplicationController
      def set_cookie
        cookies.signed[:user_id] = current_user.id
        cookies.encrypted[:expiration_date] = Date.tomorrow # => Thu, 20 Mar 2024
        redirect_to action: "read_cookie"
      end

      def read_cookie
        cookies.encrypted[:expiration_date] # => "2024-03-20"
      end
    end
    ```

    -> Signed Cookie → Ensures user_id isn’t changed.
    -> Encrypted Cookie → Hides expiration_date completely.


    -> Rails converts objects (like Date, Time, Symbols, etc.) into strings before storing them in
       cookies. 
    -> By default, Rails uses JSON serialization (:json).























