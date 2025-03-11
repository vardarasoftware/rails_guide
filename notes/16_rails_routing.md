# */*/*/*  ---> "Rails Routing from the Outside In" <---  */*/*/*


# 1 The Purpose of the Rails Router */*/*/*/*

	-> The Rails Router is responsible for mapping incoming HTTP requests to the appropriate 
	   controller actions in a Rails application. 
	-> It also helps generate URL helper methods, making it easier to manage links in the app.


  ## 1.1 Routing Incoming URLs to Code -*-*-*-*

    -> When a request is made to a Rails application, the router finds a matching route and
       directs the request to a specific controller action.
    
    ```
    GET /users/17
    ```

    -> Rails checks its routes and finds:
    ```
    get "/users/:id", to: "users#show"
    ```

    -> The request is sent to the UsersController, specifically the show action.
    -> The id parameter is extracted from the URL (params[:id] = '17').


    -> The same route can be written in different ways:
    ```
    get "/users/:id", controller: "users", action: :show
    ```

    -> These all do the same thing—directing the request to the UsersController's show action.


  
  ## 1.2 Generating Paths and URLs from Code -*-*-*-*

    -> Rails automatically generates helper methods for paths and URLs based on routes. 
    -> These helpers make it easier to refer to paths in your code without hardcoding them.

    ```
    get "/users/:id", to: "users#show", as: "user"
    ```

    -> Rails generates two helper methods:
      > user_path(@user) → Returns "/users/17"
      > user_url(@user) → Returns "https://example.com/users/17"

    
    -> In a controller:
    ```
    @user = User.find(params[:id])
    ```

    -> In a view:
    ```
    <%= link_to 'User Record', user_path(@user) %>
    ```

    -> This creates a link like:
    ```
    <a href="/users/17">User Record</a>
    ```

    -> If the route changes, we only need to update it in routes.rb rather than everywhere in our
       code.
    -> Helps maintain clean and DRY code.


  
  ## 1.3 Configuring the Rails Router -*-*-*-*

    -> In a Rails application, routes are defined in the config/routes.rb file. 
    -> This file tells Rails how to handle incoming requests and which controller actions should 
       process them.
    
    ```
    Rails.application.routes.draw do
      resources :brands, only: [:index, :show] do
        resources :products, only: [:index, :show]
      end

      resource :basket, only: [:show, :update, :destroy]

      resolve("Basket") { route_for(:basket) }
    end
    ```

    -> resources :brands creates routes for brands, but only for index and show actions.
    -> The do ... end block nests products inside brands, meaning:
      > The URL structure will be:
      > GET /brands → List all brands (BrandsController#index)
      > GET /brands/:id → Show a single brand (BrandsController#show)
      > GET /brands/:brand_id/products → List all products of a brand (ProductsController#index)
      > GET /brands/:brand_id/products/:id → Show a specific product of a brand
    -> This nesting ensures that products are always linked to a brand.

    -> This tells Rails how to resolve objects of class Basket into routes.
    -> If we use polymorphic_path(@basket), Rails will automatically map it to basket_path instead
       of requiring manual setup.




# 2 Resource Routing: the Rails Default */*/*/*/*

  -> Resource routing in Rails allows us to quickly set up routes for a controller that follows
     standard CRUD (Create, Read, Update, Delete) actions. 
  -> Instead of manually defining each route, we can use resources :photos, which automatically
     generates seven RESTful routes.
  

  ## 2.1 Resources on the Web -*-*-*-*

    -> Rails maps HTTP verbs (GET, POST, PATCH, PUT, DELETE) + URL to controller actions.

    -> When a request comes in:
      ```
      DELETE /photos/17
      ```
    
    -> And if we have the following route:
      ```
      resources :photos
      ```

    -> Rails automatically maps it to:

      ```
      PhotosController#destroy
      ```
    
    -> with params = { id: "17" }.
    -> This means Rails efficiently organizes routes for performing CRUD operations on a resource.

  
  ## 2.2 CRUD, Verbs, and Actions -*-*-*-*

    -> A single line:
      ```
      resources :photos
      ```

    -> creates seven routes, each mapped to a specific controller action:

    HTTP Verb	    Path	              Controller#Action	              Purpose

    GET	          /photos	            photos#index	                  Show all photos
    GET	          /photos/new	        photos#new	                    Form to create a new photo
    POST	        /photos	            photos#create	                  Create a new photo
    GET	          /photos/:id	        photos#show	                    Show a specific photo
    GET	          /photos/:id/edit	  photos#edit	                    Form to edit a specific photo
    PATCH         /PUT	/photos/:id	  photos#update	                  Update a specific photo
    DELETE      	/photos/:id	        photos#destroy	                Delete a specific photo



    -> Each method corresponds to a route automatically created by resources :photos.



  ## 2.3 Path and URL Helpers -*-*-*-*

    -> When we use resources :photos, Rails generates helper methods to make it easier to work 
       with these routes.
    

      Helper Method	        Returns URL	                  Usage

      photos_path	          /photos	                      link_to "All Photos", photos_path
      new_photo_path	      /photos/new	                  link_to "New Photo", new_photo_path
      edit_photo_path(10)   /photos/10/edit	              link_to "Edit", edit_photo_path(@photo)
      photo_path(10)	      /photos/10	                  link_to "View Photo", photo_path(@photo)


    -> Each _path helper has a corresponding _url helper:

      > photos_url → http://example.com/photos
      > photo_url(@photo) → http://example.com/photos/10

    

  
  ## 2.4 Defining Multiple Resources at the Same Time */*/*/*

    -> If we need routes for multiple resources, we don’t have to declare them separately.
    -> Instead, we can define them in one line:

    ```
    resources :photos, :books, :videos
    ```

    -> This is equivalent to:
      ```
      resources :photos
      resources :books
      resources :videos
      ```

    -> Each of these resources will have the standard 7 RESTful routes
       (index, show, new, create, edit, update, destroy) 
    -> mapped to their respective controllers 
       (PhotosController, BooksController, VideosController).
    
  

  ## 2.5 Singular Resources -*-*-*-*

    -> Sometimes, our application has a resource that should only have one instance per user or
       system, making an index action unnecessary. 
    -> In such cases, we use resource (singular) instead of resources (plural).

      ```
      resource :geocoder
      ```
    
    -> This does not create an index route (no /geocoders path). 
    -> Instead, it only generates routes for a single instance of Geocoder.


    -> Here are all of the routes created for a singular resource:

      HTTP Verb	   Path	          Controller#Action	         Used to

      GET	         /geocoder/new	geocoders#new	      return an HTML form for creating the geocoder
      POST         /geocoder	    geocoders#create	  create the new geocoder
      GET          /geocoder	    geocoders#show	    display the one and only geocoder resource
      GET          /geocoder/edit	geocoders#edit	    return an HTML form for editing the geocoder
      PATCH/PUT	   /geocoder	    geocoders#update	  update the one and only geocoder resource
      DELETE	     /geocoder	    geocoders#destroy	  delete the geocoder resource

    

    -> A singular resourceful route generates these helpers:

      -> new_geocoder_path returns /geocoder/new
      -> edit_geocoder_path returns /geocoder/edit
      -> geocoder_path returns /geocoder
    
    -> As with plural resources, the same helpers ending in _url will also include the host, port,
       and path prefix.
    
  

  ## 2.6 Controller Namespaces and Routing -*-*-*-*

    -> In large applications, we may want to group controllers into namespaces for better
       organization. 
    -> This is useful for areas like admin panels, API versions, or user-specific sections.

    -> Suppose we have controllers for managing articles, but they should only be accessible by
       admins. 
    -> Instead of placing them in the main app/controllers directory, we can organize them under
       app/controllers/admin/.
    
    ```
    namespace :admin do
      resources :articles
    end
    ```

    -> This automatically maps routes to the Admin::ArticlesController, meaning Rails will expect
       the controller file at:

    ```
    app/controllers/admin/articles_controller.rb
    ```

    -> Routes Created for namespace :admin

      HTTP Verb	      Path	                    Controller#Action	     Named Route Helper

      GET	          /admin/articles	          admin/articles#index	  admin_articles_path
      GET	          /admin/articles/new	      admin/articles#new	    new_admin_article_path
      POST        	/admin/articles	          admin/articles#create	  admin_articles_path
      GET         	/admin/articles/:id	      admin/articles#show	    admin_article_path(:id)
      GET         	/admin/articles/:id/edit	admin/articles#edit	    edit_admin_article_path(:id)
      PATCH/PUT	    /admin/articles/:id	      admin/articles#update	  admin_article_path(:id)
      DELETE	      /admin/articles/:id	      admin/articles#destroy	admin_article_path(:id)


    

    ### 2.6.1 Using module -----

      -> The module option allows us to route URLs normally (without a prefix like /admin) while
         mapping them to a namespaced controller.
      
      ```
      scope module: "admin" do
        resources :articles
      end
      ```

      or
      ```
      resources :articles, module: "admin"
      ```

      -> The generated URLs do not have the /admin prefix (e.g., /articles, /articles/:id).
      -> However, Rails expects the controller inside the Admin namespace
      -> Named route helpers remain the same (articles_path, new_article_path, etc.).

    
    ### 2.6.2 Using Scope -----

      -> The scope option allows us to add a path prefix (/admin) without changing the expected
         controller location.

      Example: Routing /admin/articles to ArticlesController
        ```
        scope "/admin" do
          resources :articles
        end
        ```
        
        or

        ```
        resources :articles, path: "/admin/articles"
        ```

      
      -> The generated URLs include /admin (e.g., /admin/articles, /admin/articles/:id).
      -> However, Rails looks for a normal ArticlesController, not Admin::ArticlesController.
        ```
        app/controllers/articles_controller.rb
        ```
      
      -> Named route helpers stay the same (articles_path, article_path(:id), etc.).


      -> In the last case, the following paths map to ArticlesController:

        HTTP Verb	        Path	                 Controller#Action	        Named Route Helper
        
        GET	            /admin/articles	          articles#index	          articles_path
        GET	            /admin/articles/new	      articles#new	            new_article_path
        POST	          /admin/articles	          articles#create	          articles_path
        GET	            /admin/articles/:id	      articles#show	            article_path(:id)
        GET	            /admin/articles/:id/edit	articles#edit           	edit_article_path(:id)
        PATCH/PUT	      /admin/articles/:id	      articles#update	          article_path(:id)
        DELETE	        /admin/articles/:id	      articles#destroy	        article_path(:id)


  
  ## 2.7 Nested Resources -*-*-*-*

    -> Nested resources are used when a resource belongs to another resource. 
    -> This means that one resource cannot exist independently and must be accessed through its
       parent resource.
    
    ```
    class Magazine < ApplicationRecord
      has_many :ads
    end

    class Ad < ApplicationRecord
      belongs_to :magazine
    end
    ```

    -> Here, an Ad cannot exist without a Magazine.


    -> To define this relationship in the routes file, use nested resources:

      ```
      resources :magazines do
        resources :ads
      end
      ```

      -> Ads are nested under magazines.
      -> Ads URLs will always contain a magazine_id.
    

    ->> Generated Routes for Nested Resources

  HTTP Verb	    Path	            Controller#Action	             Purpose

  GET	       /magazines/:magazine_id/ads	      ads#index	  Display all ads for a specific magazine
  GET	       /magazines/:magazine_id/ads/new	  ads#new	    Show form to create a new ad for a mag
  POST	     /magazines/:magazine_id/ads	      ads#create	Create a new ad for a specific magazine
  GET	       /magazines/:magazine_id/ads/:id	  ads#show	  Show details of a specific ad for a mag
  GET	     /magazines/:magazine_id/ads/:id/edit	ads#edit	  Show form to edit a specific ad for mag
  PATCH/PUT	 /magazines/:magazine_id/ads/:id	  ads#update	Update a specific ad for a magazine
  DELETE	   /magazines/:magazine_id/ads/:id	  ads#destroy	Delete a specific ad for a magazine




    ### 2.7.1 Limits to Nesting -----

      -> Deep nesting occurs when you define multiple levels of nested resources inside each other.
      ```
      resources :publishers do
        resources :magazines do
          resources :photos
        end
      end
      ```

      -> This means a Publisher has many Magazines.
      -> A Magazine belongs to a Publisher and has many Photos.
      -> A Photo belongs to a Magazine.


      -> The above code generates the URL would be:
        ```
        /publishers/1/magazines/2/photos/3
        ```

      -> To generate this URL in our code, we would use:
        ```
        publisher_magazine_photo_url(@publisher, @magazine, @photo)
        ```

    
    

    ### 2.7.2 Shallow Nesting ----

      -> Shallow nesting is a technique used in Rails routing to reduce the depth of nested routes
         while still maintaining logical relationships between resources.
      
      -> Why use shallow nesting:

        -> Avoids deep nesting (which makes URLs long and hard to maintain).
        -> Keeps meaningful relationships without unnecessary complexity.
        -> Makes it easier to reference child resources without always specifying parent resources.

      -> When we use shallow nesting, collection actions remain nested under the parent resource,
         while member actions are not nested.

      -> Instead of deeply nesting comments under articles, we use shallow: true:
        ```
        resources :articles do
          resources :comments, shallow: true
        end
        ```

      -> This will only nest collection actions (index, new, create) under articles, while member
         actions (show, edit, update, destroy) are not nested.



      -> If we want all nested resources to be shallow, we can declare it at the parent level:
      ```
      resources :articles, shallow: true do
        resources :comments
        resources :quotes
      end
      ```

      -> This ensures that all nested resources (comments and quotes) follow shallow nesting 
         automatically.        
      

      -> The articles resource above will generate the following routes:

      HTTP Verb	   Path	                                   Controller#Action  Named Route Helper

      GET	      /articles/:article_id/comments(.:format)	    comments#index	article_comments_path
      POST	    /articles/:article_id/comments(.:format)	    comments#create	article_comments_path
      GET	      /articles/:article_id/comments/new(.:format)	comments#new new_article_comment_path
      GET	      /comments/:id/edit(.:format)	                comments#edit	    edit_comment_path
      GET	      /comments/:id(.:format)	                      comments#show	    comment_path
      PATCH/PUT	/comments/:id(.:format)                      	comments#update	  comment_path
      DELETE	  /comments/:id(.:format)	                      comments#destroy	comment_path
      GET	      /articles/:article_id/quotes(.:format)	      quotes#index	    article_quotes_path
      POST	    /articles/:article_id/quotes(.:format)	      quotes#create	    article_quotes_path
      GET	      /articles/:article_id/quotes/new(.:format)	  quotes#new	   new_article_quote_path
      GET	      /quotes/:id/edit(.:format)	                  quotes#edit	      edit_quote_path
      GET	      /quotes/:id(.:format)	                        quotes#show	      quote_path
      PATCH/PUT	/quotes/:id(.:format)	                        quotes#update	    quote_path
      DELETE	  /quotes/:id(.:format)	                        quotes#destroy	  quote_path
      GET	      /articles(.:format)	                          articles#index	  articles_path
      POST	    /articles(.:format)	                          articles#create	  articles_path
      GET     	/articles/new(.:format)	                      articles#new	    new_article_path
      GET     	/articles/:id/edit(.:format)	                articles#edit	    edit_article_path
      GET	      /articles/:id(.:format)	                      articles#show	    article_path
      PATCH/PUT	/articles/:id(.:format)	                      articles#update	  article_path
      DELETE  	/articles/:id(.:format)	                      articles#destroy	article_path


    -> We can also use shallow do to group shallow routes:
      ```
      shallow do
        resources :articles do
          resources :comments
          resources :quotes
        end
      end
      ```

    -> This generates the same routes as the previous example.

    
    
    -> Customizing Shallow Routes

    -> we can change the path where shallow routes are placed:
      ```
      scope shallow_path: "sekret" do
        resources :articles do
          resources :comments, shallow: true
        end
      end
      ```

    -> This changes the paths for member actions to use /sekret/ instead of /comments/:

    HTTP Verb	      Path	                            Controller#Action	   Named Route Helper

    GET	          /articles/:article_id/comments	    comments#index	    article_comments_path
    POST	        /articles/:article_id/comments	    comments#create	    article_comments_path
    GET	          /articles/:article_id/comments/new	comments#new	      new_article_comment_path
    GET	          /sekret/comments/:id/edit	          comments#edit	      edit_comment_path
    GET	          /sekret/comments/:id	              comments#show	      comment_path
    PATCH/PUT	    /sekret/comments/:id	              comments#update	    comment_path
    DELETE	      /sekret/comments/:id	              comments#destroy	  comment_path



    -> We can modify route helpers by adding a prefix:
      ```
      scope shallow_prefix: "sekret" do
        resources :articles do
          resources :comments, shallow: true
        end
      end
      ```

      -> This modifies the route helpers but keeps the default paths:

      HTTP Verb	    Path	                             Controller#Action	 Named Route Helper

      GET	        /articles/:article_id/comments	      comments#index	  article_comments_path
      POST	      /articles/:article_id/comments	      comments#create	  article_comments_path
      GET	        /articles/:article_id/comments/new	  comments#new	    new_article_comment_path
      GET	        /comments/:id/edit	                  comments#edit	    edit_sekret_comment_path
      GET	        /comments/:id	                        comments#show	    sekret_comment_path
      PATCH/PUT	  /comments/:id	                        comments#update	  sekret_comment_path
      DELETE	    /comments/:id	                        comments#destroy	sekret_comment_path

  

  ## 2.8 Routing Concerns -*-*-*-*

    -> Routing concerns in Rails help us avoid code duplication when defining routes that are
       shared across multiple resources.

    -> A concern is a way to define reusable route logic that can be applied to multiple resources.
    -> Instead of writing the same resources :comments for every model that has comments,we define 
       it once in a concern, then reuse it.
    
    ```
    concern :commentable do
      resources :comments
    end

    concern :image_attachable do
      resources :images, only: :index
    end
    ```

    -> :commentable → Adds comments as a nested resource.
    -> :image_attachable → Adds images as a nested resource, but only for the index action.


    -> We can use the concern in resources:
      ```
      resources :messages, concerns: :commentable
      resources :articles, concerns: [:commentable, :image_attachable]
      ```

    -> Equivalent to Without Concerns
      ```
      resources :messages do
        resources :comments
      end

      resources :articles do
        resources :comments
        resources :images, only: :index
      end
      ````

    -> If multiple models need comments, we don’t have to manually add resources :comments inside
       each resource.

    -> Concerns can also be used inside namespace or scope blocks.

      ```
      namespace :messages do
        concerns :commentable
      end

      namespace :articles do
        concerns :commentable
        concerns :image_attachable
      end
      ````

      -> If you have multiple namespaces and we want the same nested resources, concerns keep the
         routes DRY.
  




  ## 2.9 Creating Paths and URLs from Objects -*-*-*-*

    -> In Rails, we don’t always need to manually specify IDs in our routes. 
    -> Instead, we can pass objects directly, and Rails will automatically generate the correct
       path.

    -> Let's say we have this nested resource in routes.rb:
      ```
      resources :magazines do
        resources :ads
      end
      ```

    -> This means A magazine can have multiple ads.
    -> The URL for an ad looks like:
      ```
      /magazines/:magazine_id/ads/:id
      ```

    -> Instead of passing numeric IDs, pass ActiveRecord objects.
      ```
      <%= link_to 'Ad details', magazine_ad_path(@magazine, @ad) %>
      ````

    -> Rails automatically extracts @magazine.id and @ad.id.

    -> Equivalent to magazine_ad_path:
      ```
      <%= link_to 'Ad details', url_for([@magazine, @ad]) %>
      ```

    -> Rails detects the objects and generates /magazines/5/ads/42.
    -> Even shorter way:
      ```
      <%= link_to 'Ad details', [@magazine, @ad] %>
      ```
    
    -> Works the same way but is more concise.

    -> If we just want to link to a magazine, we can pass the object directly:
      ```
      <%= link_to 'Magazine details', @magazine %>
      ```
    
    -> Rails understands this as magazine_path(@magazine)

    -> If We want to edit an ad, we must include :edit in the array:
      ```
      <%= link_to 'Edit Ad', [:edit, @magazine, @ad] %>
      ```
    
    -> Rails translates this to edit_magazine_ad_path(@magazine, @ad)

  



  ## 2.10 Adding More RESTful Routes -*-*-*-*

    -> By default, resources in Rails provides 7 standard RESTful routes:

      > index – List all records
      > show – Show a single record
      > new – Form to create a new record
      > create – Create a new record
      > edit – Form to edit a record
      > update – Update an existing record
      > destroy – Delete a record
    
    -> But sometimes, we need additional custom routes beyond these 7. 
    -> This is where member, collection, and new routes come in.

  

    ### 2.10.1 Adding Member Routes -----

      -> A member route is used for a single record. It includes the id of the resource.

      ```
      resources :photos do
        member do
          get "preview"
        end
      end
      ```

      -> Creates a new route:
      ```
      GET /photos/:id/preview
      ```

      -> Calls the preview action in PhotosController.
      -> params[:id] will contain the photo’s ID.

      -> Adds these route helpers:
      ```
      preview_photo_path(@photo)
      preview_photo_url(@photo)
      ````

      -> nstead of using a member block, you can pass :on => :member:
      ```
      resources :photos do
        get "preview", on: :member
      end
      ```

      -> Works exactly the same.

    

    ### 2.10.2 Adding Collection Routes -----

      -> A collection route applies to the entire set of resources, not just a single record.

      ```
      resources :photos do
        collection do
          get "search"
        end
      end
      ```

      -> Creates a new route:
      ```
      GET /photos/search
      ```

      -> Calls the search action in PhotosController.
      -> No id is required in the URL.
      -> Adds these route helpers:
        ```
        search_photos_path 
        search_photos_url  
        ```

      -> Shorter Syntax 
        > Instead of using a collection block, we can pass :on => :collection:
        ```
        resources :photos do
          get "search", on: :collection
        end
        ```
      
      -> Works exactly the same





# 3 Non-Resourceful Routes */*/*/*/*

  -> Rails provides resourceful routing (using resources) to generate a set of standard RESTful
     routes automatically. 
  -> However, sometimes we may need custom, non-resourceful routes when:
    > We want a custom URL that doesn't fit the RESTful pattern.
    > We need to map old URLs to new actions.
    > We need a single, standalone route without a full resource.

  
  ##  3.1 Bound Parameters -*-*-*-*

    -> Bound parameters allow you to define optional URL segments.

    ```
    get "photos(/:id)", to: "photos#display"
    ```

    -> If the user requests /photos/1, Rails calls PhotosController#display with:
      ```params[:id] # => "1" ```
    
    -> If the user requests /photos, the id is not required, and Rails still calls display.


  
  ## 3.2 Dynamic Segments -*-*-*-*

    -> Dynamic segments allow Rails to capture parts of the URL as parameters.
    
    ```
    get "photos/:id/:user_id", to: "photos#show"
    ```

    -> A request to /photos/1/2 will result in:
    ```
    params[:id]      # => "1"
    params[:user_id] # => "2"
    ```

    -> Rails extracts the values from the URL and makes them available as params.

  

  ## 3.3 Static Segments -*-*-*-*

    -> we can mix static segments with dynamic segments.
    
    ```
    get "photos/:id/with_user/:user_id", to: "photos#show"
    ```

    -> A request to /photos/1/with_user/2 will result in:
    ```
    params[:id]      # => "1"
    params[:user_id] # => "2"
    ```

    -> Static words (with_user) must be included in the URL for the route to match.


  ## 3.4 Query String Parameters -*-*-*-*

    -> Query string parameters are appended to the URL using ?key=value.

    ```
    get "photos/:id", to: "photos#show"
    ```

    -> A request to /photos/1?user_id=2 will result in:
    ```
    params[:id]      # => "1"
    params[:user_id] # => "2"
    ```

    -> Query strings are optional and can contain additional paramete


  
  ## 3.5 Defining Default Parameters -*-*-*-*

    -> Rails allows us to set default values for route parameters using the :defaults option.

    ```
    get "photos/:id", to: "photos#show", defaults: { format: "jpg" }
    ```

    -> A request to /photos/12 will automatically set:
    ```
    params[:id]     # => "12"
    params[:format] # => "jpg"
    ```

    -> A request to /photos/12.png will override the default and set format: "png".



    ```
    defaults format: :json do
      resources :photos
      resources :articles
    end
    ```

    -> Now, all responses from photos and articles will have format: json unless specified 
       otherwise.
    -> We cannot override default parameters using query strings.
    -> Only URL path segments (like /photos/12.xml) can override them.

  

  ## 3.6 Naming Routes  -*-*-*-*

    -> We can assign custom names to your routes using the :as option.

    ```
    get "exit", to: "sessions#destroy", as: :logout
    ```

    -> nstead of using sessions_destroy_path, you can now use:
      ```
      logout_path 
      logout_url
      ````
    
    -> Overriding Resourceful Route Names
    ```
    get ":username", to: "users#show", as: :user
    resources :users
    ```


    -> Instead of user_path(@user), you can now use:
      ```
      user_path("jane") # => "/jane"
      ```
    -> Inside UsersController#show, params[:username] will contain "jane".
    -> Place the custom route before the resources :users block so Rails matches it first.

  

  ## 3.7 HTTP Verb Constraints -*-*-*-*

    -> We can restrict routes to specific HTTP verbs using get, post, put, patch, and delete.

    ```
    match "photos", to: "photos#show", via: [:get, :post]
    ```
    -> Both GET and POST requests to /photos will call PhotosController#show.


    -> Allowing All HTTP Methods
    
    ```
    match "photos", to: "photos#show", via: :all
    ```
    -> Any HTTP method (GET, POST, PATCH, etc.) will be routed to show.


    -> Use match only when we need multiple verbs; otherwise, prefer explicit methods like get.


  
  ## 3.8 Segment Constraints -*-*-*-*

    ```
    get "photos/:id", to: "photos#show", constraints: { id: /[A-Z]\d{5}/ }
    ```

    -> The id parameter must:
      > Start with an uppercase letter (A-Z).
      > Be followed by 5 digits (\d{5}).
      > Matches: /photos/A12345
    -> Does NOT match: /photos/12345 or /photos/abcd


    -> Shorter Way to Write It
      ```
      get "photos/:id", to: "photos#show", id: /[A-Z]\d{5}/
      ```
    
    -> Same behavior as the previous example, but more concise.


    -> Using Regular Expressions in Constraints
      ```
      get "/:id", to: "articles#show", constraints: { id: /^\d/ }
      ```

    -> Invalid Constraint
    -> Rails automatically anchors routes (i.e., it treats them as ^ and $).
    -> Solution: Just use /\d.+/ instead of /^\d/.


      ```
      get "/:id", to: "articles#show", constraints: { id: /\d.+/ }
      ```

    ->  Valid Constraint
    -> id must start with a digit (\d).
    -> Matches: /1-hello-world (routes to ArticlesController#show).
    -> Does NOT match: /hello-world (won't match this route).


  
  ## 3.9 Request-Based Constraints -*-*-*-*


    -> Rails allows us to restrict routes based on request properties, such as the subdomain or 
       format.
    
    ```
    get "photos", to: "photos#index", constraints: { subdomain: "admin" }
    ```

    -> This route only matches requests made to the admin subdomain.


    -> Using Constraints in a Namespace:
    
    ```
    namespace :admin do
      constraints subdomain: "admin" do
        resources :photos
      end
    end
    ```

    -> Creates RESTful routes (index, show, new, etc.) for PhotosController under the admin namespace.
    -> These routes only work for requests under the admin subdomain (admin.example.com).

  

  ## 3.10 Advanced Constraints -*-*-*-*

    -> Advanced constraints let you restrict access to routes based on custom logic, such as IP-based
       restrictions, user roles, or any request-based condition. 
    -> These constraints can be defined using classes, lambdas, or block forms.

    -> We can create a custom constraint class that checks conditions before allowing a request to 
       match a route.
    
    ```
    class RestrictedListConstraint
      def initialize
        @ips = RestrictedList.retrieve_ips
      end

      def matches?(request)
        @ips.include?(request.remote_ip)
      end
    end

    Rails.application.routes.draw do
      get "*path", to: "restricted_list#index",
        constraints: RestrictedListConstraint.new
    end
    ```

    -> RestrictedList.retrieve_ips fetches restricted IPs.
    -> The matches? method checks if the request's IP is in the list.
    -> If yes, the request is routed to "restricted_list#index".
    -> If no, the request is ignored (other routes are checked).


    -> Instead of defining a class, we can use a lambda function.

    ```
    Rails.application.routes.draw do
      get "*path", to: "restricted_list#index",
        constraints: lambda { |request| RestrictedList.retrieve_ips.include?(request.remote_ip) }
    end
    ```

    -> The lambda receives the request object and checks if the remote_ip is in the restricted list.
    -> If yes, the request goes to "restricted_list#index".
    -> If no, it moves to other routes.



    ### 3.10.1 Constraints in a Block Form -----

      -> If we need to apply the same constraint to multiple routes, we can use a block.

      ```
      Rails.application.routes.draw do
        constraints(RestrictedListConstraint.new) do
          get "*path", to: "restricted_list#index"
          get "*other-path", to: "other_restricted_list#index"
        end
      end
      ````

      -> Both routes use the same RestrictedListConstraint.
      -> If the IP is restricted, requests are sent to:
        > "restricted_list#index" (for *path)
        > "other_restricted_list#index" (for *other-path)

      

      -> Using a Lambda for Block Constraints

      ```
      Rails.application.routes.draw do
        constraints(lambda { |request| RestrictedList.retrieve_ips.include?(request.remote_ip) }) do
          get "*path", to: "restricted_list#index"
          get "*other-path", to: "other_restricted_list#index"
        end
      end
      ```

      ->  Same behavior, but without defining a separate class.

  

  ## 3.11 Wildcard Segments -*-*-*-*

    -> Wildcard segments allow us to capture an arbitrary part of a URL and store it in params.

    ```
    get "photos/*other", to: "photos#unknown"
    ```

    -> /photos/12 → params[:other] = "12"
    -> /photos/long/path/to/12 → params[:other] = "long/path/to/12"
    -> *other captures everything after /photos/.
    -> The value is stored in params[:other].
    -> The request is sent to PhotosController#unknown.



    -> Wildcards can appear before or after specific segments.
    ```
    get "books/*section/:title", to: "books#show"
    ```

    -> Everything after /books/ until /:title is stored in params[:section].
    -> The last segment is assigned to params[:title].



    -> Multiple Wildcard Segments
    ```
    get "*a/foo/*b", to: "test#index"
    ```
    -> *a captures everything before /foo/.
    -> *b captures everything after /foo/.
    -> The request goes to TestController#index

  


  ## 3.12 Format Segments -*-*-*-*

    -> In Rails, format segments allow us to specify the response format as part of the URL. 
    -> The format parameter is automatically captured from the URL when present.

    ```
    get "*pages", to: "pages#show"
    ```

    -> If a request is made to /about/contact.json
      > params[:pages] = "about/contact"
      > params[:format] = "json"
    -> Rails automatically extracts .json as the format.
    -> we don’t have to explicitly define :format in the route—it’s optional by default.


    ->> If we want to ignore format extensions in URLs, use format: false.
    ```
    get "*pages", to: "pages#show", format: false
    ```

    -> Matches /about/contact
    -> Does NOT match /about/contact.json
    -> params[:format] will always be nil
    -> This is useful if our routes should not handle formats explicitly.


    
    ->> If we want to force users to specify a format in the URL, use format: true.

    ```
    get "*pages", to: "pages#show", format: true
    ```

    -> Only matches URLs that include a format:
      > /about/contact.json
      > params[:format] will always be present.
    -> This is useful when our API or frontend strictly requires a format, like JSON responses.

  


  ## 3.13 Redirection -*-*-*-*

    -> Rails allows us to redirect routes to different paths using the redirect helper. 
    -> This is useful when we need to permanently or temporarily redirect traffic from one route to
       another.

    ```
    get "/stories", to: redirect("/articles")
    ```

    -> When a user visits /stories, they will be redirected to /articles.


    -> We can reuse dynamic URL segments in the redirect:
    ```
    get "/stories/:name", to: redirect("/articles/%{name}")
    ```

    -> Request to /stories/rails-guide → Redirects to /articles/rails-guide


    -> We can define custom logic for redirection using a block:
    ```
    get "/stories/:name", to: redirect { |path_params, req| "/articles/#{path_params[:name].pluralize}" }
    ```

    -> Request to /stories/book → Redirects to /articles/books (pluralized)


    -> We can also access the request object to generate dynamic redirects:
    ```
    get "/stories", to: redirect { |path_params, req| "/articles/#{req.subdomain}" }
    ```

    -> If the request comes from tech.example.com/stories, it redirects to /articles/tech


    -> By default, Rails uses 301 Moved Permanently, which some browsers cache aggressively.
    -> If we want a temporary redirect (302), we can specify it:
    ```
    get "/stories/:name", to: redirect("/articles/%{name}", status: 302)
    ```

    -> Use 301 for permanent redirects (SEO-friendly but cached)
    -> Use 302 for temporary redirects (useful for testing or dynamic changes)

  


  ## 3.14 Routing to Rack Applications -*-*-*-*

    -> Rails routes can directly call a Rack application instead of a controller action. 
    -> This allows integrating middleware, custom Rack apps, or external services directly into our
       Rails app.

    
    -> Instead of routing to a controller action like:
      ```
      get "/articles", to: "articles#index"
      ```
    
    -> We can route to a Rack application:
      ```
      match "/application.js", to: MyRackApp, via: :all
      ```
    
    -> MyRackApp must be a Rack-compliant application, meaning it must respond to call(env) and 
       return [status, headers, body].
    -> via: :all ensures the route works for all HTTP methods (GET, POST, PUT, DELETE, etc.).



    -> If we use match, our Rack application must expect the full route path:
      ```
      match "/admin", to: AdminApp, via: :all
      ```
    
    -> Here, AdminApp must handle /admin internally.

    -> But if we want AdminApp to receive requests at the root (/), use mount:
      ```
      mount AdminApp, at: "/admin"
      ```
    
    -> Now, inside AdminApp, paths will start from /, not /admin.

  

  ## 3.15 Using root -*-*-*-*

    -> The root method in Rails is used to define the default route for your application, 
       i.e., what should be displayed when a user visits / (the home page).
    
    ```
    root to: "pages#main"
    root "pages#main" # shortcut for the above
    ```

    -> This means that when a user visits the root URL (/), Rails will direct them to the main action
       in the PagesController.
    

    -> We can define different root paths for different parts of our application:
      ```
      namespace :admin do
        root to: "admin#index"
      end
      ```

    -> This means that visiting /admin will go to AdminController's index action.
    -> The regular root (/) still maps to HomeController#index if defined as root to: "home#index".


  
  ## 3.16 Unicode Character Routes -*-*-*-*

    -> Rails allows using Unicode characters in routes:
      ```
      get "こんにちは", to: "welcome#index"
      ```

    -> This maps GET /こんにちは to the index action of the WelcomeController. 
    -> Useful for applications with non-English URLs.

  

  ## 3.17 Direct Routes -*-*-*-*

    -> Direct routes let you create custom URL helpers.

    ```
    direct :homepage do
      "https://rubyonrails.org"
    end
    ```

    -> Now calling homepage_url in our views or controllers returns "https://rubyonrails.org".

    -> Using Direct Routes with Models
      ```
      direct :commentable do |model|
        [model, anchor: model.dom_id]
      end
      ```

    -> This generates URLs that link to a specific model and include an anchor.
    -> Using Direct Routes for Controllers
      ```
      direct :main do
        { controller: "pages", action: "index", subdomain: "www" }
      end
      ```
    
    -> This creates main_url, which points to "http://www.example.com/pages".

  

  ## 3.18 Using resolve -*-*-*-*

    -> The resolve method customizes how Rails generates paths for polymorphic URLs.

      ```
      resource :basket
      resolve("Basket") { [:basket] }
      ```
    
    -> Normally, Rails would generate URLs like /baskets/:id for a Basket model.
    -> The resolve method makes it use /basket instead of /baskets/:id in path helpers.

    -> uses in forms:
      ```
      <%= form_with model: @basket do |form| %>
        <!-- basket form -->
      <% end %>
      ```
    
    -> Without resolve, Rails would generate /baskets/:id.
    -> With resolve("Basket") { [:basket] }, it generates /basket.





# 4 Customizing Resourceful Routes */*/*/*/*

  -> By default, when we define resourceful routes using resources :photos, Rails automatically
     assumes that the controller is named PhotosController. 
  -> However, we can customize which controller handles a resource using the controller option.


  ## 4.1 Specifying a Controller to Use -*-*-*-*

    -> If we want a different controller to handle the resource, use the controller option.

    ```
    resources :photos, controller: "images"
    ```

    -> The URL still uses /photos, but Rails directs requests to the ImagesController instead of
       PhotosController.

    
    -> How Rails Maps Requests:

    HTTP Verb	                Path	            Controller#Action	              Named Route Helper

    GET	                    /photos	               images#index	                  photos_path
    GET	                    /photos/new	           images#new	                    new_photo_path
    POST	                  /photos	               images#create	                photos_path
    GET	                    /photos/:id	           images#show	                  photo_path(:id)
    GET	                    /photos/:id/edit	     images#edit	                  edit_photo_path(:id)
    PATCH/PUT	              /photos/:id	           images#update	                photo_path(:id)
    DELETE	                /photos/:id	           images#destroy	                photo_path(:id)


    -> If our database model is called Photo, but we want to handle it inside an ImagesController.
    -> If we're refactoring our app but want to keep existing URLs.


    -> If our controller is inside a namespace, we can define it like this:
      ```
      resources :user_permissions, controller: "admin/user_permissions"
      ```
    
    -> This will route to: Admin::UserPermissionsController

  

  ## 4.2 Specifying Constraints on id -*-*-*-*

    -> By default, Rails allows any numerical or string value for the id in resourceful routes.
    -> However, we can restrict what values are accepted using constraints.

    ```
    resources :photos, constraints: { id: /[A-Z][A-Z][0-9]+/ }
    ```

    -> The id must start with two uppercase letters followed by numbers.
    -> /photos/RR27 → Valid
    -> /photos/1 → Invalid because it doesn’t match the pattern
    -> /photos/abc123 → Invalid lowercase letters


    -> Applying Constraints to Multiple Resources
    -> Instead of adding constraints to each resource separately, we can apply them to multiple 
       resources using a block:
      ```
      constraints(id: /[A-Z][A-Z][0-9]+/) do
        resources :photos
        resources :accounts
      end
      ```
    
    -> Now, both /photos/XX99 and /accounts/YY88 are valid, but /photos/1 or /accounts/abc123 are not.

  


  ## 4.3 Overriding Named Route Helpers -*-*-*-*

    -> By default, Rails uses the resource name to generate path helpers.
    -> For example, resources :photos generates:
      > photos_path
      > new_photo_path
      > edit_photo_path(:id)
    
    -> We can rename the route helpers using the :as option.

    ```
    resources :photos, as: "images"
    ```

    -> URL remains /photos routes still work as expected
    -> Path helpers change to images_path instead of photos_path


    -> Updated Route Helpers
      HTTP Verb	        Path	          Controller#Action	              Named Route Helper

      GET	            /photos	              photos#index	                images_path
      GET	            /photos/new	          photos#new	                  new_image_path
      POST          	/photos	              photos#create	                images_path
      GET	            /photos/:id	          photos#show	                  image_path(:id)
      GET	            /photos/:id/edit	    photos#edit	                  edit_image_path(:id)
      PATCH/PUT     	/photos/:id	          photos#update	                image_path(:id)
      DELETE	        /photos/:id	          photos#destroy	              image_path(:id)

    
    -> This is useful when: we want more user-friendly route helpers.
    -> we are refactoring but keeping the existing URL structure. 

  

  ## 4.4 Renaming new and edit Path Names -*-*-*-*

    -> By default: new maps to /photos/new, edit maps to /photos/:id/edit

    -> we can rename them using :path_names to make URLs more readable.

    -> Example: Customizing new and edit Paths
      ```
      resources :photos, path_names: { new: "make", edit: "change" }
      ```
    
    -> The controller actions remain the same (new and edit).
    -> The helper methods are NOT changed
    -> new_photo_path still works, but it points to /photos/make
    -> edit_photo_path(:id) still works, but it points to /photos/:id/change



    -> Applying Path Name Changes Globally
    -> If we want to apply path_names changes to all routes:
      ```
      scope path_names: { new: "make" } do
        resources :photos
        resources :articles
      end
      ```
    
    -> All resources inside the scope will use /make instead of /new.
    -> /photos/make instead of /photos/new
    -> /articles/make instead of /articles/new

  
  


  ## 4.5 Prefixing the Named Route Helpers with :as -*-*-*-*

    -> The :as option allows us to rename route helpers so they don’t conflict with similar routes.

    ```
    scope "admin" do
      resources :photos, as: "admin_photos"
    end

    resources :photos
    ```

    -> Normally, Rails generates route helpers like photos_path, new_photo_path, etc.
    -> Since we have an admin/photos route inside a scope "admin", adding as: "admin_photos" ensures
       that the admin routes don't override the general photo routes.
    
    -> Now, we get: admin_photos_path for admin photos, photos_path for regular photos.
    -> Without the as: "admin_photos", the general photos routes would not have any route helpers.



    -> If we want to prefix multiple routes at once, we can use :as inside a scope.
    ```
    scope "admin", as: "admin" do
      resources :photos, :accounts
    end

    resources :photos, :accounts
    ```

    -> This renames all routes inside admin/ to use admin_ as a prefix.
    -> Now, we have: admin_photos_path, admin_accounts_path, photos_path, accounts_path 

  


  ## 4.6 Using :as in Nested Resources -*-*-*-*

    -> If we have nested resources, we can also rename the route helpers.

    ```
    resources :magazines do
      resources :ads, as: "periodical_ads"
    end
    ```

    -> Normally, Rails would generate: magazine_ads_path, edit_magazine_ad_path
    -> With as: "periodical_ads", it changes to: magazine_periodical_ads_path,
       edit_magazine_periodical_ad_path
    -> This makes it clearer that these ads belong to a magazine periodical.

  


  ## 4.7 Parametric Scopes -*-*-*-*

    -> We can add a dynamic segment to the route using scope.
      ```
      scope ":account_id", as: "account", constraints: { account_id: /\d+/ } do
        resources :articles
      end
      ```

    -> The :account_id in the URL represents an account’s ID, must be a number due to constraints.


    -> The helper method:
      ```
      account_article_path(@account, @article) # => "/1/articles/9"
      ```

    -> This allows us to reference params[:account_id] inside controllers.


  



  ## 4.8 Restricting the Routes Created -*-*-*-*

    -> By default, resources generates all the standard RESTful routes:
      > index, show, new, create, edit, update, destroy
    -> We can limit this using :only or :except.

    -> Using :only
      ```
      resources :photos, only: [:index, :show]
      ```
    
    -> Only allows index and show routes.
    -> This means: GET /photos or GET /photos/:id Works and POST /photos or DELETE /photos/:id Fails.

    -> Using :except
      ```
      resources :photos, except: :destroy

    -> Creates all routes except destroy.
    -> This means: index, show, new, create, edit, update
    -> DELETE /photos/:id Does not exist

    
  

  ## 4.9 Translated Paths -*-*-*-*

    -> We can change the default paths in Rails routes to different languages or custom names using 
       scope.
    
    ```
    scope(path_names: { new: "neu", edit: "bearbeiten" }) do
      resources :categories, path: "kategorien"
    end
    ```

    -> categories becomes kategorien
    -> new_category_path (default /categories/new) becomes /kategorien/neu
    -> edit_category_path(@category) (default /categories/:id/edit) becomes /kategorien/:id/bearbeiten


    -> Generated Routes:

      HTTP Verb	        Path	                Controller#Action	                Helper Method

      GET	          /kategorien	                categories#index	             categories_path
      GET	          /kategorien/neu	            categories#new	               new_category_path
      POST	        /kategorien	                categories#create	             categories_path
      GET	          /kategorien/:id	            categories#show	               category_path(:id)
      GET           /kategorien/:id/bearbeiten	categories#edit	               edit_category_path(:id)
      PATCH/PUT	    /kategorien/:id	            categories#update	             category_path(:id)
      DELETE	      /kategorien/:id	            categories#destroy	           category_path(:id)

  




  ## 4.10 Specifying the Singular Form of a Resource -*-*-*-*

    -> Rails automatically converts singular and plural words, but if we need a custom conversion,
       we can modify it.

    -> Example: Fixing Irregular Pluralization
    -> By default, Rails doesn’t know that the plural of "tooth" is "teeth", so we define it manually:

    ```
    ActiveSupport::Inflector.inflections do |inflect|
      inflect.irregular "tooth", "teeth"
    end
    ```

    -> What This Does
      > Rails now knows tooth (singular) → teeth (plural).
      > If we have a Tooth model, Rails will now look for /teeth instead of /tooths.

    



  ## 4.11 Renaming Default Route Parameter id -*-*-*-*

    -> Rails provide functnality to rename id to something else.

    -> Example: Changing id to identifier
      ```
      resources :videos, param: :identifier
      ```

    -> Generated Routes:

      HTTP Verb	      Path	                Controller#Action	          Helper Method

      GET	          /videos	                  videos#index	            videos_path
      POST	        /videos	                  videos#create	            videos_path
      GET	          /videos/new	              videos#new	              new_video_path
      GET	          /videos/:identifier/edit	videos#edit	              edit_video_path(:identifier)

    
    -> Example Usage in Controller
      ```
      Video.find_by(identifier: params[:identifier]) 
      # Instead of: Video.find_by(id: params[:id])
      ```


    ->  Overriding to_param in the Model
    -> WE can make Rails use a custom identifier instead of id.

    -> Example: Using identifier Instead of id
      ```
      class Video < ApplicationRecord
        def to_param
          identifier  # This replaces the default `id` in URLs
        end
      end
      ```

    
    -> How It Works
      ```
      video = Video.find_by(identifier: "Roman-Holiday")
      edit_video_path(video)  # => "/videos/Roman-Holiday/edit"
      ```

      








