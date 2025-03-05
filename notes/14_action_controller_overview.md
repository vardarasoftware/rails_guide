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
    



























