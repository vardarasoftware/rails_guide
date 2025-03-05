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
    
    

