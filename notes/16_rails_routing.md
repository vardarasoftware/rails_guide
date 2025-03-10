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




















