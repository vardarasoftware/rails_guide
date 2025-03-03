### */*/*/*  Layouts and Rendering in Rails */*/*/*/*

# 1 Overview: How the Pieces Fit Together */*/*/*/*

  -> This guide explains how the Controller and View work together in a Rails application.
  -> When a user makes a request (like opening a webpage), the Controller takes charge.
  -> The Controller processes the request, often asking the Model for data.
  -> Once the data is ready, the Controller passes it to the View, which is responsible for
     displaying the response to the user.
  -> The Controller decides what kind of response to send (like an HTML page or JSON).
  -> It calls a method to generate that response.
  -> If it's a full webpage, Rails adds extra elements like a layout and may include partial
     views
    

# 2 Creating Responses */*/*/*/*

  -> In a Rails Controller, there are three ways to send a response to the user:

    -> render → Sends a complete response (usually an HTML page).
    -> redirect_to → Sends an HTTP redirect, telling the browser to visit another URL.
    -> head → Sends only HTTP headers without any content

    

  ## 2.1 Rendering by Default: Convention Over Configuration in Action -------

    -> Rails follows the "convention over configuration" principle, meaning that it
       automatically follows a set of default rules instead of requiring manual setup. 
    -> One of these rules applies to how views are rendered by controllers.

    -> How Default Rendering Works
      -> If a controller doesn’t explicitly call render, Rails automatically looks for a
         view file that matches the action name.
      -> For example, if you visit /books, Rails will look for index.html.erb inside 
         app/views/books/.
      -> If the file exists, it will be displayed without needing any extra code in 
         the controller.
        
    i.  initial setup

      -> controller is empty:

      ```
      class BooksController < ApplicationController
      end
      ```

      -> routes define a resource:

      ```
      resources :books
       ```

      -> view exists:

      ```
      <h1>Books are coming soon!</h1>
      ```

      -> If we visit /books, Rails automatically renders index.html.erb.

        
    ii. adding data with a model

      -> When you add a Book model and define the index action:

      ```
      class BooksController < ApplicationController
        def index
          @books = Book.all
        end
      end
      ```

      -> Rails still automatically renders index.html.erb even though there is no render
        call in the index method.
      -> The only difference is that now @books contains all books from the database, which
        the view can use.
            
        
    iii. displaying the books in the view

      -> The index.html.erb file loops through @books and displays each book’s title 
         and content inside an HTML table:
            
      ```
      <h1>Listing Books</h1>

      <table>
      <thead>
        <tr>
          <th>Title</th>
          <th>Content</th>
          <th colspan="3"></th>
        </tr>
      </thead>

      <tbody>
        <% @books.each do |book| %>
          <tr>
            <td><%= book.title %></td>
            <td><%= book.content %></td>
            <td><%= link_to "Show", book %></td>
            <td><%= link_to "Edit", edit_book_path(book) %></td>
            <td><%= link_to "Destroy", book, data: { turbo_method: :delete, turbo_confirm: "Are you sure?" } %></td>
          </tr>
        <% end %>
      </tbody>
      </table>

      <br>

      <%= link_to "New book", new_book_path %>

      ```

      -> This template:
      -> Lists all books in a table.
      -> Shows links for viewing, editing, and deleting books.
      -> Provides a "New book" button to create a new book.


  
  ## 2.2 Using render -----
    -> The render method in a Rails controller is responsible for generating the response that
       is sent to the user's browser. 
    -> Rails provides many ways to customize how content is rendered.


    ### 2.2.1 Rendering an Action's View--

      -> When an action needs to re-render a different view, we can use the 'render' method.

      -> Example: Handling Validation Errors in an Update Action
        -> A user updates a book (or in your case, a notebook) through a form.
        -> If the update succeeds, the user is redirected to the show page.
        -> If the update fails, the edit form is re-rendered to let the user fix the errors.

      ```
      def update
        @book = Book.find(params[:id])
        if @book.update(book_params)
          redirect_to(@book)
        else
          render "edit"
        end
      end
      ```

      -> If @book.update(book_params) fails (due to validation errors), Rails will render 
         edit.html.erb inside app/views/books/.
      -> This lets the user fix errors without losing form data.



      -> Instead of render "edit", we can use render :edit
      ```
      def update
        @book = Book.find(params[:id])
        if @book.update(book_params)
          redirect_to(@book)
        else
          render :edit, status: :unprocessable_entity
        end
      end
      ```
      -> It sets an HTTP 422 status code, which tells the browser that the request failed due to
         validation errors.
      
    

    ### 2.2.2 Rendering an Action's Template from Another Controller ----

      -> Normally, Rails renders a template that matches the controller and action name
         automatically. 
      -> Sometimes, we may want to render a view from a different controller.

      ```
      class NoteBooksController < ApplicationController
        def show
          @note_book = NoteBook.find(params[:id])
          render "books/show"
        end
      end
      ```
      -> This tells Rails to use app/views/books/show.html.erb instead of 
         app/views/note_books/show.html.erb.
      
    

    ### 2.2.3 Wrapping it up 

      -> This section explains various ways to render a view template in Rails.

      -> Rendering a Template from the Same Controller
        -> In a controller (e.g. NoteBooksController), when an action (like update) needs to
           render a template from the same controller, we have multiple ways to do it
      
      ```
      render :edit
      render action: :edit
      render "edit"
      render action: "edit"
      render "books/edit"
      render template: "books/edit"
      ```

      -> Rails automatically assumes the template is inside app/views/books/, so just render
         ':edit' is enough

      -> Here, Rails understands that books/edit.html.erb belongs to BooksController.
    

    ### 2.2.4 Using render with :inline

      -> The render inline method allows us to write ERB (Embedded Ruby) directly inside the
         controller, instead of using a separate .html.erb file in the views folder.
      
      ```
      render inline: "<% products.each do |p| %><p><%= p.name %></p><% end %>"
      ```

      -> This will loop through the products collection and display each product's name inside 
         a <p> tag.

      
      ```
      render inline: "xml.p {'Horrid coding practice!'}", type: :builder
      ```
      ->  This forces Rails to use Builder format instead of ERB.

    
    ### 2.2.5 Rendering Text

      -> The render plain method sends raw text (without HTML formatting) as the response to the
         browser.

      ```
      render plain: "OK"
      ```
      ->  This sends a simple "OK" message as plain text to the browser.

    
    ### 2.2.6 Rendering HTML

      -> The render html method sends raw HTML content as the response to the browser.

      ```
      render html: helpers.tag.strong("Not Found")
      ```
      ->  This sends HTML-formatted text back to the browser.

    

    ### 2.2.7 Rendering JSON

      ```
      render json: @product
      ```

      -> Rails automatically converts @product into JSON format.
      -> You don’t need to call .to_json explicitly.
      -> The response header will have Content-Type: application/json.

    
    ### 2.2.8 Rendering XML

      ```
      render xml: @product
      ```
      
      -> Rails converts @product into XML format automatically.
      -> You don’t need to call .to_xml explicitly.
      -> The response header will have Content-Type: application/xml.


    ### 2.2.9 Rendering Vanilla JavaScript

      ```
      render js: "alert('Hello Rails');"
      ```

      -> Rails sends the JavaScript string as a response.
      -> The browser executes it as JavaScript.
      -> The MIME type will be text/javascript.

    
    ### 2.2.10 Rendering Raw Body

      ```
      render body: "raw"
      ```

      -> Rails sends the string as-is without setting any Content-Type.
      -> This is the lowest-level rendering method.

      -> When sending raw content that does not need specific formatting.
      -> When debugging server responses.

    
    ### 2.2.11 Rendering Raw File

      ```
      render file: "#{Rails.root}/public/404.html", layout: false
      ```

      -> Loads a static file (like an error page) without processing it.
      -> The layout is included by default, but you can disable it with layout: false.
      -> Does not support ERB, meaning no dynamic content can be added.\

    

    ### 2.2.12 Rendering Objects

      -> In Rails, we can render objects that implement the #render_in method. 
      -> This method is called with the view context, allowing the object to generate its 
         own rendered output.
      
      ```
      class Greeting
        def render_in(view_context)
          view_context.render html: "Hello, World"
        end

        def format
          :html
        end
      end
      ```

      -> The Greeting class has two methods:
      -> render_in(view_context):
        -> This method takes the view_context (which represents the current view environment in Rails).
        -> It calls view_context.render html: "Hello, World", meaning it renders "Hello, World" as HTML.
      -> format:
        -> This method returns :html, which defines the format the object is meant to be rendered in.

      

      ```
      render Greeting.new
      # => "Hello World"
      ```
      -> When we call render Greeting.new, Rails:
      -> Checks if the object (Greeting.new) responds to render_in.
      -> Calls Greeting.new.render_in(view_context), passing the current view context.
      -> Executes view_context.render html: "Hello, World", rendering "Hello, World" in HTML.


    ### 2.2.13 Options for render

      -> Calls to the render method generally accept six options:
        -> :content_type
        -> :layout
        -> :location
        -> :status
        -> :formats
        -> :variants
      

      #### 2.2.13.1 The :content_type Option

        -> By default, Rails sets the MIME type based on the type of content being rendered:
          -> HTML → text/html
          -> JSON → application/json, if using render json:
          -> XML → application/xml, if using render xml:

        ```
        render template: "feed", content_type: "application/rss"
        ```
        -> This tells Rails to render the "feed" template.
        -> Instead of using the default text/html, it sets the content type to RSS, which is useful for RSS feeds.


      #### 2.2.13.2 The :layout Option

        -> By default, Rails wraps rendered content inside a layout.
        -> we can control this behavior using the :layout option.

        ```
        render layout: "special_layout"
        ```
        -> Instead of using the default layout (application.html.erb), this tells Rails to use "special_layout".
        -> This is useful when different pages need different layouts.


        --> Rendering without a layout

        ```
        render layout: false
        ```
        -> This disables the layout entirely.
        -> The rendered content will be raw output without being wrapped in any layout.

      

      #### 2.2.13.3 The :location Option 

        -> The :location option sets the Location HTTP header, which tells the client 
           where the resource is located.
        ```
        render xml: photo, location: photo_url(photo)
        ```

        -> Renders photo as XML.
        -> Sets the Location header to the URL of the photo (photo_url(photo)).
        -> This is useful when responding to an API request that creates a resource.


      #### 2.2.13.4 The :status Option 

        -> Rails allows both numeric codes (e.g., 200, 404) and symbols (e.g., :ok, :not_found).

        ---------------------------------------------------------------------------------------
        Response Class	      HTTP Status Code	          Symbol

        Informational	        100	                        :continue
                              101	                        :switching_protocols
                              102	                        :processing
        Success	              200	                        :ok
                              201	                        :created
                              202	                        :accepted
                              203	                        :non_authoritative_information
                              204	                        :no_content
                              205	                        :reset_content
                              206	                        :partial_content
                              207	                        :multi_status
                              208	                        :already_reported
                              226	                        :im_used
        Redirection	          300	                        :multiple_choices
                              301	                        :moved_permanently
                              302	                        :found
                              303	                        :see_other
                              304	                        :not_modified
                              305	                        :use_proxy
                              307	                        :temporary_redirect
                              308	                        :permanent_redirect
        Client Error	        400	                        :bad_request
                              401	                        :unauthorized
                              402	                        :payment_required
                              403	                        :forbidden
                              404	                        :not_found
                              405	                        :method_not_allowed
                              406	                        :not_acceptable
                              407	                        :proxy_authentication_required
                              408	                        :request_timeout
                              409	                        :conflict
                              410	                        :gone
                              411	                        :length_required
                              412	                        :precondition_failed
                              413	                        :payload_too_large
                              414	                        :uri_too_long
                              415	                        :unsupported_media_type
                              416	                        :range_not_satisfiable
                              417                         :expectation_failed
                              421	                        :misdirected_request
                              422	                        :unprocessable_entity
                              423	                        :locked
                              424	                        :failed_dependency
                              426	                        :upgrade_required
                              428	                        :precondition_required
                              429	                        :too_many_requests
                              431	                        :request_header_fields_too_large
                              451	                        :unavailable_for_legal_reasons
        Server Error	        500	                        :internal_server_error
                              501	                        :not_implemented
                              502	                        :bad_gateway
                              503	                        :service_unavailable
                              504	                        :gateway_timeout
                              505	                        :http_version_not_supported
                              506	                        :variant_also_negotiates
                              507	                        :insufficient_storage
                              508	                        :loop_detected
                              510	                        :not_extended
                              511	                        :network_authentication_required
        ------------------------------------------------------------------------------------------      


      #### 2.2.13.5 The :formats Option 

        -> By default, Rails detects the format from the request.
        -> However, we can override this behavior using the :formats option.

        ```
        render formats: :xml
        render formats: [:json, :xml]
        ```

        -> Forces Rails to look for an .xml.erb template instead of the default .html.erb.
        -> Rails will first look for a .json.erb template.
        -> If not found, it will try a .xml.erb template.
        -> If neither exists, it will raise an ActionView::MissingTemplate error.

      

      #### 2.2.13.6 The :variants Option

        -> The :variants option allows you to serve different versions of the same view based on 
           the device type e.g., mobile vs. desktop or any other condition.

        ```
        # Called in HomeController#index
        render variants: [:mobile, :desktop]
        ````

        -> Rails will look for templates in the following order:

          > app/views/home/index.html+mobile.erb
          > app/views/home/index.html+desktop.erb
          > app/views/home/index.html.erb (default if no variant template exists)

        
        -> Instead of setting :variants inside render, we can set it globally for the request.

        ```
        class HomeController < ApplicationController
          def index
            request.variant = determine_variant
          end

          private

          def determine_variant
            :mobile if session[:use_mobile]  # Example condition
          end
        end
        ```

        -> If 'session[:use_mobile]' is true, Rails will look for 'index.html+mobile.erb'.
        -> Otherwise, it defaults to 'index.html.erb'.


    ### 2.2.14 Finding Layouts

      -> In Rails, layouts act as a wrapper for our views, allowing you to maintain a consistent 
         structure. 
      -> Rails automatically determines which layout to use based on a few rules.

      ---> How layout work

      -> If we have BlogPostController, Rails will first check for:
      //--> app/views/layouts/blog_post.html.erb

      -> This layout will apply only to action inside BlogPostController.

      -> If blog_post.html.erb does not exist, Rails will use:
      //--> app/views/layouts/application.html.erb

      -> This is the default layout for all controller.


      --> Builder layout For API responce
      
      -> If there is no .erb layout, Rails will check for:
      //--> app/views/layouts/blog_post.builder

      -> This is usefull for API responce like XML or JSON.



      ### 2.2.14.1 Specifying Layouts for Controllers

        -> We can override the default layout for a specific controller by declaring it inside the class.

        ```
        class BlogPostController < ApplicationController
          layout "blog_layout"
        end
        ```
        -> Now, all actions in BlogPostController will use:
          "app/views/layouts/blog_layout.html.erb"
        
        -> Even though Rails would normally look for blog_post.html.erb, it will now use 
           blog_layout.html.erb instead.
        

        -> To apply a universal layout to all controllers, define it inside ApplicationController.

        ```
        class ApplicationController < ActionController::Base
          layout "main"
        end
        ```
        -> Now, all controllers inherit from ApplicationController, so they will use:
           "app/views/layouts/main.html.erb"
        
        -> Unless a controller explicitly specifies a different layout, this one will be used.

      
      #### 2.2.14.2 Choosing Layouts at Runtime

        -> we can define a method inside the controller that returns the appropriate layout.

        ```
        class BlogPostController < ApplicationController
          layout :blog_post_layout

          private

          def blog_post_layout
            current_user.admin? ? "admin_dashboard" : "blog_layout"
          end
        end
        ```

        -> If the user is an admin, they get admin_dashboard.html.erb.
        -> Otherwise, they see blog_layout.html.erb.


        -> we can also use a Proc (lambda function) to dynamically set the layout.
        ```
        class BlogPostController < ApplicationController
          layout Proc.new { |controller| controller.request.xhr? ? "popup" : "application" }
        end
        ```
        -> If the request is an AJAX request (xhr?), Rails will use popup.html.erb.
        -> Otherwise, it will use the default application.html.erb.


      
      #### 2.2.14.3 Conditional Layouts

        -> Rails allows you to conditionally apply layouts to different actions inside a 
           controller. 
        -> This is done using the ':only' and ':except' options when specifying a layout.

        ```
        class BlogPostsController < ApplicationController
          layout "blog_layout", except: [:index, :show]
        end
        ```

        -> For actions like new, edit, create, etc., Rails will use 
           app/views/layouts/blog_layout.html.erb.
        -> For index and show, Rails will fall back to the default layout (application.html.erb),
           or no layout if specified.

      
      #### 2.2.14.4 Layout Inheritance

        -> Layout inheritance in Rails means that child controllers can automatically use the
           layout defined in their parent controller. 
        -> This helps maintain a consistent look and feel across multiple controllers without
           having to specify the layout in each one.

        //--> application_controller.rb
        ```
        class ApplicationController < ActionController::Base
          layout "main"
        end
        ```

        //--> artical_controller.rb
        ```
        class ArticlesController < ApplicationController
        end
        ```

        //--> special_artical_controller.rb
        ```
        class SpecialArticlesController < ArticlesController
          layout "special"
        end
        ```

        //--> old_artical_controller.rb
        ```
        class OldArticlesController < SpecialArticlesController
          layout false

          def show
            @article = Article.find(params[:id])
          end

          def index
            @old_articles = Article.older
            render layout: "old"
          end
          # ...
        end
        ```


        -> In this application:
          -> In general view will be rendered in main layout.
          -> ArticalController #index will use the main layout.
          -> SpecialArticalCOntroller #index will use tha special layout'
          -> OldArticalController #show will use no layout at all.
          -> OldArticalController #index will use the old layout.
        
      
      #### 2.2.14.5 Template Inheritance
        
        -> Template inheritance in Rails means that if a specific view template or partial is 
           missing in the expected directory, Rails will search for it in its inheritance hierarchy.
        -> This allows controllers that belong to the same module or application to share
           templates efficiently.
        
        ```
        # app/controllers/application_controller.rb
        class ApplicationController < ActionController::Base
        end

        # app/controllers/admin_controller.rb
        class AdminController < ApplicationController
        end

        # app/controllers/admin/products_controller.rb
        class Admin::ProductsController < AdminController
          def index
          end
        end
        ```

        -> View Lookup Order for Admin::ProductsController#index
        -> Rails will search for the index.html.erb template in this order:
          > app/views/admin/products/index.html.erb
          > app/views/admin/index.html.erb
          > app/views/application/index.html.erb
          > If the template is not found in admin/products/, it will check admin/. 
          > If still not found, it will check application/.
        


    ### 2.2.15 Avoiding Double Render Errors

      -> In Rails, a "Can only render or redirect once per action" error occurs when you try to
         call render or redirect_to multiple times within a single controller action.
      -> This happens because once Rails starts rendering a view, it cannot render another view 
         or redirect within the same action.
      
      -> Understanding the issue

      ```
      def show
        @book = Book.find(params[:id])
        if @book.special?
          render action: "special_show"
        end
        render action: "regular_show"
      end
      ```

      -> If @book.special? is true, the controller renders "special_show".
      -> But the code keeps executing after render, reaching render action: "regular_show".
      -> Rails cannot render two views in one request, so it throws an error.


      -> Fix the issue

      ```
      def show
        @book = Book.find(params[:id])
        if @book.special?
          render action: "special_show"
        end
      end
      ```

      -> After render action: "special_show", the return statement stops execution.
      -> This prevents Rails from reaching render action: "regular_show", avoiding the double
         render error.
  

  ## 2.3 Using redirect_to ----

    #--> "redirect_to"
    -> The redirect_to method is used to instruct the browser to make a new request to a 
       different URL. 
    -> This means the browser discards the current request and initiates a fresh request to 
       the given path.
    
    ```
    redirect_to photos_url
    ```
    -> This tells the browser to navigate to photos_url, which typically maps to the index page 
       of the photos resource.

    -> How it Works?
      > The browser receives an HTTP 302 (Found) or HTTP 301 (Moved Permanently) response.
      > It then makes a new request to the specified URL.
      > This is different from render, which simply renders a view without making a new request.


    #--> "redirect_back"
    -> The redirect_back method is used to send the user back to the previous page they were on.

    ```
    redirect_back(fallback_location: root_path)
    ```
    -> It checks the HTTP_REFERER header in the request, which stores the last visited page.
    -> If HTTP_REFERER is present, it redirects the user back to that page.
    -> If HTTP_REFERER is not set, it redirects to fallback_location.


    ### 2.3.1 Getting a Different Redirect Status Code

      -> By default, Rails uses HTTP status code 302 (Found, Temporary Redirect) when calling
         redirect_to. 
      -> However, we can specify a different status code using the :status option.

      -> When we use redirect_to without specifying a status, Rails automatically assigns HTTP
         status 302 (Temporary Redirect). This means:
        > The browser is told to make a new request.
        > The original URL is not changed in search engine indexing.
      
      ```
      redirect_to photos_path, status: 302
      ```


      -> If you want to indicate that a URL has moved permanently, we should use HTTP status 301.
      -> This tells search engines and browsers that the resource has a new permanent location.

      ```
      redirect_to photos_path, status: 301
      ```
      -> If your website changes its URL structure, a 301 redirect ensures users and search
         engines update to the new URL.
    

    ### 2.3.2 The Difference Between render and redirect_to

      -> render vs redirect_to Behavior
        > render
          -> Renders a view template inside the same request.
          -> Does not call another action
          -> Keeps instance variables (@variable) available for the view.
        > redirect_to
          -> Tells the browser to make a new request.
          -> Executes a new controller action and runs its code.
          -> Does NOT keep instance variables
      

      ```
      def index
        @books = Book.all
      end

      def show
        @book = Book.find_by(id: params[:id])
        if @book.nil?
          render action: "index"
        end
      end
      ```

      -> If @book is nil, it tries to render the index view, but does not execute the index action.
      -> The index.html.erb view might expect @books, but since index was not actually executed,
         @books is nil, causing errors.
      



      ```
      def index
        @books = Book.all
      end

      def show
        @book = Book.find_by(id: params[:id])
        if @book.nil?
          redirect_to action: :index
        end
      end
      ```

      -> If @book is nil, it redirects to index.
      -> This sends a 302 redirect response to the browser.
      -> The browser makes a new request for /books, triggering index to run.
      -> The index action executes normally and sets @books properly.

      

      -> To avoid an extra request, we can manually load @books and use render instead of
         redirect_to:

      ```
      def index
        @books = Book.all
      end

      def show
        @book = Book.find_by(id: params[:id])
        if @book.nil?
          @books = Book.all
          flash.now[:alert] = "Your book was not found"
          render "index"
        end
      end
      ```

      -> Instead of redirecting, it directly renders the index view.
      -> It manually loads @books to prevent missing variables.
      -> Uses flash.now[:alert] to show a message only for this request
      -> Faster response time

  

  ## 2.4 Using head to Build Header-Only Responses ---

    -> The head method in Rails is used to send responses with only headers, without rendering 
       any views or returning a body. 
    -> This is useful when you only need to inform the client about the status of their request
       without sending HTML or JSON data.
    
    ```
    head :bad_request
    ```
    -> Rails sends an HTTP 400 Bad Request response.
    -> No HTML or JSON is sent—only the response headers.

    -> Actual Response Header Sent to Browser
    ```
    HTTP/1.1 400 Bad Request
    Connection: close
    Date: Sun, 24 Jan 2010 12:15:53 GMT
    Transfer-Encoding: chunked
    Content-Type: text/html; charset=utf-8
    X-Runtime: 0.013483
    Set-Cookie: _blog_session=...snip...; path=/; HttpOnly
    Cache-Control: no-cache
    ```


    -> we can also include additional headers in the response:
    ```
    head :created, location: photo_path(@photo)
    ```
    -> Rails sends an HTTP 201 Created response.
    -> It also includes a Location header to tell the client where the new resource is located.

    -> Actual Response Header Sent to Browser
    ```
    HTTP/1.1 201 Created
    Connection: close
    Date: Sun, 24 Jan 2010 12:16:44 GMT
    Transfer-Encoding: chunked
    Location: /photos/1
    Content-Type: text/html; charset=utf-8
    X-Runtime: 0.083496
    Set-Cookie: _blog_session=...snip...; path=/; HttpOnly
    Cache-Control: no-cache
    ```



# 3 Structuring Layouts */*/*/*/*

  -> When Rails renders a view, it combines that view with a layout to create the final response.
  -> Layouts help maintain a consistent structure across your application while allowing 
     individual views to insert their unique content.
    
    > Asset tags
    > yield and content_for
    > Partials

  

  ## 3.1 Asset Tag Helpers ----

    -> Asset tag helpers generate HTML tags to include JavaScript, CSS, images, videos, and 
       audios in your views. 
    -> They help in managing assets efficiently and ensuring paths are correctly resolved.

    -> auto_discovery_link_tag
    -> javascript_include_tag
    -> stylesheet_link_tag
    -> image_tag
    -> video_tag
    -> audio_tag

    
    ### 3.1.1 Linking to Feeds with the auto_discovery_link_tag

      -> The auto_discovery_link_tag helper automatically generates a <link> tag in the <head>
         section of our HTML to help browsers and feed readers detect RSS, Atom, or JSON feeds.
      
      ```
      <%= auto_discovery_link_tag(:rss, {action: "feed"},
      {title: "RSS Feed"}) %>
      ```

      -> :rss → The type of feed (:rss, :atom, or :json).
      -> { action: "feed" } → Specifies the URL for the feed.
      -> { title: "RSS Feed" } → Sets the title for the link.

      --> Generated HTML:
      ```
      <link rel="alternate" type="application/rss+xml" title="RSS Feed" href="/feed.rss">
      ```

    
    ### 3.1.2 Linking to JavaScript Files with the javascript_include_tag

      -> The javascript_include_tag helper generates an HTML <script> tag to include JavaScript
         files in your Rails application.
      
      ```
      <%= javascript_include_tag "main" %>
      ```

      -> Generated HTML
      ```
      <script src='/assets/main.js'></script>
      ```
      -> This will automatically load app/assets/javascripts/main.js.


      -->  How It Works with the Asset Pipeline
        -> Before Rails 3.1 → JavaScript files were stored in public/javascripts/ and manually
           included.
        -> With Asset Pipeline (Rails 3.1+) → JavaScript files are stored in:
          > app/assets/javascripts/
          > lib/assets/javascripts/
          > vendor/assets/javascripts/
        -> Rails compiles and serves JavaScript from these locations through /assets/ instead of /
           public/.
      

      ```
      <%= javascript_include_tag "main", "columns" %>
      ```

      -> Generated HTML:
      ```
      <script src='/assets/main.js'></script>
      <script src='/assets/columns.js'></script>
      ```



      -> If the file is inside app/assets/javascripts/photos/columns.js, we need to specify the
         full path:
      ```
      <%= javascript_include_tag "main", "/photos/columns" %>
      ```

      -> Generated HTML:
      ```
      <script src='/assets/main.js'></script>
      <script src='/assets/photos/columns.js'></script>
      ```



      -> If we want to load a script from an external URL, we can specify the full URL:

      ```
      <%= javascript_include_tag "https://example.com/main.js" %>
      ```

      -> Generated HTML:
      ```
      <script src='https://example.com/main.js'></script>
      ```
    

    ### 3.1.3 Linking to CSS Files with the stylesheet_link_tag

      -> The stylesheet_link_tag helper generates an HTML <link> tag to include CSS files in our
         Rails application.
      
      ```
      <%= stylesheet_link_tag "main" %>
      ```

      -> Generated HTMl:
      ```
      <link rel="stylesheet" href="/assets/main.css" />
      ```
      -> This will automatically load app/assets/stylesheets/main.css.


      -> Including Multiple CSS Files
      ```
      <%= stylesheet_link_tag "main", "columns" %>
      ```

      -> Generated HTML:
      ```
      <link rel="stylesheet" href="/assets/main.css" />
      <link rel="stylesheet" href="/assets/columns.css" />
      ```



      -> Including CSS from a Subdirectory
      -> If the file is inside app/assets/stylesheets/photos/columns.css, we need to specify the
         full path
      
      ```
      <%= stylesheet_link_tag "main", "photos/columns" %>
      ```

      -> Generated HTML:
      ```
      <link rel="stylesheet" href="/assets/main.css" />
      <link rel="stylesheet" href="/assets/photos/columns.css" />
      ```


      -> Including an External CSS File
      -> If we want to load a stylesheet from an external URL, we can specify the full URL:
      ```
      <%= stylesheet_link_tag "https://example.com/main.css" %>
      ```

      -> Generated HTML:
      ```
      <link rel="stylesheet" href="https://example.com/main.css" />
      ```


      -> By default, stylesheet_link_tag sets rel="stylesheet", but you can override it using 
         the :rel option:
      ```
      <%= stylesheet_link_tag "main_print", media: "print" %>
      ```

      -> Generated HTML:
      ```
      <link rel="stylesheet" href="/assets/main_print.css" media="print" />
      ```

      -> This is useful for print stylesheets, which apply only when printing a page.


    

    ### 3.1.4 Linking to Images with the image_tag

      -> The image_tag helper in Rails is used to generate an HTML <img> tag for displaying 
         images in your views. 
      -> It automatically points to the app/assets/images directory or public/images.

      -> To display an image, use:
      ```
      <%= image_tag "header.png" %>
      ```

      -> This generates:
      ```
      <img src="/assets/header.png" />
      ```
      -> The image should be inside app/assets/images/ or public/images/.



      -> If our image is inside a subfolder like app/assets/images/icons/, use:

      ```
      <%= image_tag "icons/delete.gif" %>
      ```

      -> This generates:
      ```
      <img src="/assets/icons/delete.gif" />
      ```



      -> You can customize the <img> tag by passing additional HTML attributes:

      -> Setting Width & Height
      ```
      <%= image_tag "icons/delete.gif", height: 45 %>
      ```

      -> This Generates:
      ```
      <img src="/assets/icons/delete.gif" height="45" />
      ```


      -> Setting Custom Size
      -> Instead of height and width, we can use size: "WxH":
      ```
      <%= image_tag "home.gif", size: "50x20" %>
      ```

      -> Generates:
      ```
      <img src="/assets/home.gif" width="50" height="20" />
      ```



    ### 3.1.5 Linking to Videos with the video_tag

      -> The video_tag helper in Rails generates an HTML5 <video> tag to embed videos in our 
         views. 
      -> By default, it loads videos from the public/videos directory or the asset pipeline.


      -> To display a video, use:
      ```
      <%= video_tag "movie.ogg" %>
      ```
      -> This generates:
      ```
      <video src="/videos/movie.ogg"></video>
      ```

      -> The video file should be placed inside public/videos/ or app/assets/videos/.


      -> Multiple Video Sources for Browser Compatibility
      -> Different browsers support different video formats. To provide multiple formats:

      ```
      <%= video_tag ["trailer.ogg", "movie.ogg"] %>
      ```

      -> This will generates
      ```
      <video>
        <source src="/videos/trailer.ogg">
        <source src="/videos/movie.ogg">
      </video>
      ```

      -> Some browsers support MP4 but not OGG (or vice versa).
      -> The browser will pick the first supported format.

    

    ### 3.1.6 Linking to Audio Files with the audio_tag

      -> The audio_tag helper in Rails generates an HTML5 <audio> tag to embed and play audio 
         files in your views. 
      -> By default, it loads files from public/audios/ or app/assets/audios/


      -> To embed an audio file in your view:
      ```
      <%= audio_tag "music.mp3" %>
      ```

      -> This Generates:
      ```
      <audio src="/audios/music.mp3"></audio>
      ```

      -> By default, Rails looks for the file in public/audios/.


      -> If your audio file is inside a folder like app/assets/audios/songs/, use:
      ```
      <%= audio_tag "songs/first_song.mp3" %>
      ```

      -> This Generates:
      ```
      <audio src="/assets/songs/first_song.mp3"></audio>
      ```
  

  ## 3.2 Understanding yield ----

    -> In Rails layouts, yield is used to insert content from the current view into the layout.
    -> This helps create a consistent structure for multiple pages while allowing each page to
       insert its own unique content.
    
    -> The simplest way to use yield is to have one placeholder where the content of the current
       view will be inserted.

    ```
    <html>
      <head>
        <title>My Blog</title>
      </head>
      <body>
        <%= yield %>
      </body>
    </html>
    ```

    -> Here, yield acts as a placeholder for the content of the current view.
    -> If we're rendering posts/show.html.erb, the content from show.html.erb will be inserted
       where <%= yield %> is.
    


    --> we can have multiple yield placeholders in a layout. 
    --> These are called named yield regions, and they allow inserting content into specific
        sections of the layout.
    
    ```
    <html>
      <head>
        <%= yield :head %>
      </head>
      <body>
        <%= yield %>
      </body>
    </html>
    ```



  ## 3.3 Using the content_for Method -----

    -> The content_for method in Rails allows you to insert page-specific content into a named
       yield block in your layout. 
    -> This is useful when you want to customize certain sections while still using a shared
       layout for multiple pages.
    -> Instead of inserting content everywhere with <%= yield %>, content_for lets we define 
       specific placeholders where different content can be inserted.

      ```
      <% content_for :head do %>
        <title>A simple page</title>
      <% end %>

      <p>Hello, Rails!</p>
      ```

      -> Generated HTMl:
      ```
      <html>
        <head>
          <title>A simple page</title>
        </head>
        <body>
          <p>Hello, Rails!</p>
        </body>
      </html>
      ```

  ## 3.4 Using Partials ---

    ### 3.4.1 Naming Partials 

      -> In Rails, partials are reusable view templates that help avoid duplication and organize
         our views efficiently. 
      -> They are mainly used when a piece of HTML is repeated across multiple pages, such as
         menus, sidebars, or comment sections.
      
      -> Partials are named with a leading underscore (_) to distinguish them from regular views.
      -> However, when rendering a partial, we omit the underscore.

      -> Let's say we have a menu that appears on every page.
      ```
      <%= render "menu" %>
      ```

      -> Naming Rule: The file starts with an underscore (_menu.html.erb).


      -> If our partial is inside a different folder, specify the folder name.
      -> Location: app/views/application/_menu.html.erb

      ```
      <%= render "application/menu" %>
      ```
      -> This will render the file app/views/application/_menu.html.erb.

    
    ### 3.4.2 Using Partials to Simplify Views

      -> Partials in Rails help break down complex views into smaller, reusable components,
         making the code more maintainable and readable.

      ```
      <%= render "application/ad_banner" %>

      <h1>Products</h1>

      <p>Here are a few of our fine products:</p>
      <%# ... %>

      <%= render "application/footer" %>
      ```

      -> <%= render "application/ad_banner" %>
      -> This renders the _ad_banner.html.erb partial located in app/views/application/. 
      -> It could contain an advertisement banner that appears on multiple pages.

      -> <%= render "application/footer" %>
      -> This includes the _footer.html.erb partial, which could be a common footer section
         shared across different pages.

      
      -> There are two pages, users/index.html.erb and roles/index.html.erb, which have similar
         search forms but with different input fields.

        -> users/index.html.erb
        ```
        <%= render "application/search_filters", search: @q do |form| %>
          <p>
            Name contains: <%= form.text_field :name_contains %>
          </p>
        <% end %>
        ```

        -> roles/index.html.erb
        ```
        <%= render "application/search_filters", search: @q do |form| %>
          <p>
            Title contains: <%= form.text_field :title_contains %>
          </p>
        <% end %>
        ```

        -> Both views use the same partial (application/_search_filters.html.erb), but they pass
           different form fields.

        
        -> application/_search_filters.html.erb

        ```
        <%= form_with model: search do |form| %>
          <h1>Search form:</h1>
          <fieldset>
            <%= yield form %>
          </fieldset>
          <p>
            <%= form.submit "Search" %>
          </p>
        <% end %>
        ```

        -> render "application/search_filters", search: @q do |form|
          > This renders the _search_filters.html.erb partial and passes @q as the search 
            parameter.
          > The do |form| block captures the form object and allows customization inside each
            view.
        
        -> <%= yield form %>
          > yield acts as a placeholder inside the partial.
          > It receives the block from render, which defines specific search field

    


    ### 3.4.3 Partial Layouts

      -> Just like a full view can use a layout, partials can also have their own layouts. 
      -> This is useful when you want to wrap a partial in some extra structure without modifying
         the main layout.
      
      ```
      <%= render partial: "link_area", layout: "graybar" %>
      ```

      -> The '_link_area.html.erb' partial will be rendered.
      -> It will be wrapped inside the _graybar.html.erb layout.
      -> The '_graybar.html.erb' layout will be in the same folder as '_link_area.html.erb'.



    ### 3.4.4 Local Variables

      -> Partials in Rails can receive local variables, allowing us to make them more flexible
         and reusable. 
      -> There are two main ways to pass local variables to a partial:

      -> Using as: to Rename Collection Items
        
        -> When rendering a collection of objects, Rails automatically assigns each object to a
           variable named after the partial. 
        -> However, we can rename this variable using the as: option.

        ```
        <%= render partial: "product", collection: @products, as: :item %>
        ```

        -> This renders _product.html.erb for each @products item.
        -> Instead of using the default variable (product), you can now access each product as
           item inside the partial.

        
      -> Passing Custom Local Variables with locals:

        -> We can also send additional local variables to a partial using locals:.

        ```
        <%= render partial: "product", collection: @products, 
           as: :item, locals: { title: "Products Page" } %>
        ```

        -> title: "Products Page" creates a local variable title inside _product.html.erb.
    

    
    ### 3.4.5 Counter Variables

      -> When we render a collection in Rails, Rails automatically provides a counter variable to
         keep track of how many times the partial has been rendered. 
      -> This is useful for indexing items, adding numbering, or applying conditional styling.

      -> If you render a collection of blog posts, Rails creates a counter variable named
         blogpost_counter, starting from 0
      
      ```
      <%= render partial: "blogpost", collection: @blogposts %>
      ````

      -> For each blog post in @blogposts, _blogpost.html.erb is rendered.


      -> If you rename the collection variable using as:, the counter variable also changes.
      ```
      <%= render partial: "blogpost", collection: @blogposts, as: :article %>
      ```

      -> Now, inside _blogpost.html.erb, the counter variable will be article_counter instead of
         blogpost_counter.

      
    

    #### 3.4.6 Spacer Templates

      ->A spacer template is a second partial that is rendered between each item in a collection. 
      -> This is useful when you want to add dividers, separators, or extra content between items.

      -> When you use the spacer_template: option, Rails will:
        -> Render the main partial (_blogpost.html.erb) for each blog post in @blogposts.
        -> Insert the spacer partial (_divider.html.erb) between each blog post.
        -> The spacer partial does not receive data from the collection.


      ```
      <%= render partial: @blogposts, spacer_template: "divider" %>
      ```

      -> This renders _blogpost.html.erb for each blog post in @blogposts.
      -> Between each blog post, _divider.html.erb will be inserted.


    
    ### 3.4.7 Collection Partial Layouts

      -> When rendering a collection of items in Rails, we can wrap each item in a layout partial
         using the layout: option. 
      -> This helps we apply consistent structure or styling around each individual item in the 
         collection.
      
      -> When using layout: "special_layout", Rails will:
        > Render the main partial (e.g., _blogpost.html.erb) for each item in @blogposts.
        > Wrap each blog post inside a layout partial (_special_layout.html.erb).
        > Pass both the current object (blogpost) and the counter variable 'blogpost_counter' to
          the layout.
      
      ```
      <%= render partial: "blogpost", collection: @blogposts, layout: "post_wrapper" %>
      ```

      -> Each @blogpost is rendered using _blogpost.html.erb.
      -> Each _blogpost.html.erb is wrapped inside _post_wrapper.html.erb.



  

  ## 3.5 Using Nested Layouts -----

    -> In some cases, we need a slightly different layout for a specific controller but still
       want to reuse most of the main layout. 
    -> Instead of duplicating the entire layout, you can use nested layouts (sub-templates) to
       extend the base layout and make small modifications.
    
    -> This is the default layout used by most of the application.
    ```
    <html>
    <head>
      <title><%= @page_title or "Page Title" %></title>
      <%= stylesheet_link_tag "layout" %>
      <%= yield :head %>
    </head>
    <body>
      <div id="top_menu">Top menu items here</div>
      <div id="menu">Menu items here</div>
      <div id="content"><%= content_for?(:content) ? yield(:content) : yield %></div>
    </body>
    </html>
    ```


    --> Custom Layout for NewsController (news.html.erb)
      -> Instead of replacing the whole layout, this layout:
      -> Hides the top menu
      -> Adds a right-side menu inside #content
      -> Still inherits everything from application.html.erb
    
    ```
    <% content_for :head do %>
      <style>
        #top_menu {display: none}  /* Hide the top menu */
        #right_menu {float: right; background-color: yellow; color: black}
      </style>
    <% end %>

    <% content_for :content do %>
      <div id="right_menu">Right menu items here</div> <!-- Custom right menu -->
      <%= content_for?(:news_content) ? yield(:news_content) : yield %>
    <% end %>

    <%= render template: "layouts/application" %>  <!-- Render the base layout -->
    ```



    -> The news.html.erb layout removes the top menu and adds a right menu.
    -> The main content of news/index.html.erb is inserted into content_for :news_content.
    -> Finally, news.html.erb renders application.html.erb, meaning it still includes most of the
       original layout structure.
    

    





























































