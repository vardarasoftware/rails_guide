# */*/*/* ---> Action Controller Advanced Topic <--- */*/*/*

# Introduction */*/*/*

  -> This guide covers a number of advanced topics related to controllers in a Rails application.



# 2 Authenticity Token and Request Forgery Protection */*/*/*

  -> Cross-Site Request Forgery (CSRF) is a type of attack where a hacker tricks a user’s browser
     into making unwanted actions on a trusted website where the user is already logged in.
  
  -> Rails automatically protects our application by adding a CSRF token to each form and request. 
  -> This token is a unique secret value that is only known to the server.


  -> How protection works:
    > Rails generates a CSRF token and stores it in the session.
    > This token is added to all forms as a hidden field.
    > When a request is made, Rails compares the received token with the stored one.
    > If the token doesn’t match or is missing, Rails rejects the request to prevent the attack.
  
  -> The CSRF token is added automatically when config.action_controller.
     default_protect_from_forgery is set to true, which is the default for newly created Rails applications. 
  -> It can also be manually like this:
  ```
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  end
  ```


  ## 2.1 Authenticity Token in Forms -*-*-*-*

    -> When we use form_with in Rails, Rails automatically includes the CSRF token:

    ```
    <%= form_with model: @user do |form| %>
      <%= form.text_field :username %>
      <%= form.text_field :password %>
    <% end %>
    ```
    

    -> Generated HTML:
    ```
    <form accept-charset="UTF-8" action="/users/1" method="post">
    <input type="hidden"
          value="67250ab105eb5ad10851c00a5621854a23af5489"
          name="authenticity_token"/>
    <!-- fields -->
    </form>
    ```

    -> The hidden authenticity_token field ensures the request is genuine.





# 3 Controlling Allowed Browser Versions */*/*/*

  -> Rails restrict access to our application based on the browser version using the allow_browser
     method in ApplicationController.
  
  -> Rails by default allows only the latest browsers:
    > Safari 17.2+, Chrome 120+, Firefox 121+, Opera 106+

  ```
  class ApplicationController < ActionController::Base
    # Only allow modern browsers supporting webp images, web push, badges, import # maps, CSS nesting, and CSS :has.
    allow_browser versions: :modern
  end
  ```

  -> We can manually specify which browser versions to allow.
  ```
  class ApplicationController < ActionController::Base
    allow_browser versions: { safari: 16.4, firefox: 121, ie: false }
  end
  ```

  -> This customization Allows Safari 16.4+, Firefox 121+, Blocks Internet Explorer (IE) completely
     and Allows all versions of Chrome & Opera
  


  -> We can apply browser restrictions only to specific actions using only or except.

  ```
  class MessagesController < ApplicationController
    allow_browser versions: { opera: 104, chrome: 119 }, only: :show
  end
  ```

  -> This customization Blocks Opera below 104 and Chrome below 119, Only applies to the show
     action and Other actions are not affected

  



# 4 HTTP Authentication */*/*/*/*

  -> Rails comes with three built-in HTTP authentication mechanisms:

    > Basic Authentication
    > Digest Authentication
    > Token Authentication

  
  ## 4.1 HTTP Basic Authentication -*-*-*-*

    -> This is the simplest method where a user enters a username and password in a browser popup
       before accessing a page. 
    -> The credentials are sent in the HTTP header with every request.

    ```
    class AdminsController < ApplicationController
      http_basic_authenticate_with name: "Arthur", password: "42424242"
    end
    ```
    -> Now, when users try to access any action in AdminsController, they must enter the username 
       (Arthur) and password (42424242).

    -> How it works:

      > The browser asks for a username & password.
      > The credentials are encoded and sent with each request.
      > If they match, the user is granted access.

  

  ## 4.2 HTTP Digest Authentication -*-*-*-*

    -> Unlike Basic Authentication, Digest Authentication does not send plain text passwords.
    -> It uses a hashed version of the password that ensures passwords are never transmitted
       directly over the network.
    
    ```
    class AdminsController < ApplicationController
      USERS = { "admin" => "helloworld" }

      before_action :authenticate

      private
        def authenticate
          authenticate_or_request_with_http_digest do |username|
            USERS[username]
          end
        end
    end
    ```

    -> The browser asks for a username & password.
    -> Instead of sending the password directly, it sends a hashed digest.
    -> Rails checks the hash and grants access if it matches.




  ## 4.3 HTTP Token Authentication -*-*-*-*

    -> Instead of asking for a username & password every time, the user gets a token after logging 
       in. 
    -> The token is then sent in the request header instead of credentials.

    ```
    class PostsController < ApplicationController
      TOKEN = "secret"

      before_action :authenticate

      private
        def authenticate
          authenticate_or_request_with_http_token do |token, options|
            ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
          end
        end
    end
    ```

    -> A user logs in and receives a unique token (e.g., "secret").
    -> The token is stored on the client side.
    -> For every request, the client sends the token in the HTTP Authorization header
    -> The server compares the token and grants access if it matches.





# 5 Streaming and File Downloads */*/*/*

  -> Rails allows us to send files to users instead of rendering an HTML page. 
  -> This is useful for downloading PDFs, CSVs, images, or other files. 
  -> We can achieve this using two methods:
    > send_data
    > send_file

  
  -> When we generate a file dynamically like a PDF, use send_data. 
  -> This method does not require a physical file on disk; instead, it sends generated data
     directly to the client.
  
  ```
  require "prawn"
  class ClientsController < ApplicationController
    # Generates a PDF document with information on the client and
    # returns it. The user will get the PDF as a file download.
    def download_pdf
      client = Client.find(params[:id])
      send_data generate_pdf(client),
                filename: "#{client.name}.pdf",
                type: "application/pdf"
    end

    private
      def generate_pdf(client)
        Prawn::Document.new do
          text client.name, align: :center
          text "Address: #{client.address}"
          text "Email: #{client.email}"
        end.render
      end
  end
  ```

  -> generate_pdf(client) → Creates a PDF in memory using Prawn (a Ruby PDF library).
  -> send_data → Streams the generated PDF as a downloadable file.
  -> filename: "#{client.name}.pdf" → Sets the downloaded file name.
  -> type: "application/pdf" → Tells the browser it's a PDF file.



  ## 5.1 Sending Files -*-*-*-*

    -> The send_file method in Rails is used when we want to send an existing file from our server
       to the user's browser for download. 
    -> This is useful when we have already generated and stored a file (like a PDF, image, or 
       document) and want the user to download it.

    ```
    class ClientsController < ApplicationController
      # Stream a file that has already been generated and stored on disk.
      def download_pdf
        client = Client.find(params[:id])
        send_file("#{Rails.root}/files/clients/#{client.id}.pdf",
                  filename: "#{client.name}.pdf",
                  type: "application/pdf")
      end
    end
    ```

    -> Find the Client → Client.find(params[:id])
    -> Fetches the client record from the database using the ID provided in the URL.
    -> Locate the File → "#{Rails.root}/files/clients/#{client.id}.pdf"
    -> Assumes that the PDF file is stored in the files/clients/ directory inside the Rails
       project.
    -> Uses Rails.root to get the root path of your project dynamically.
    -> Send the File Using send_file
    -> filename: "#{client.name}.pdf" → Renames the file to the client’s name when downloaded.
    -> type: "application/pdf" → Tells the browser that it's a PDF file.



  ## 5.2 RESTful Downloads -*-*-*-*

    -> In a RESTful application, each resource can have multiple representations.
    -> Instead of creating a separate action like download_pdf, we can handle file downloads
       within the show action itself using respond_to.
    
    ```
    class ClientsController < ApplicationController
      # The user can request to receive this resource as HTML or PDF.
      def show
        @client = Client.find(params[:id])

        respond_to do |format|
          format.html
          format.pdf { render pdf: generate_pdf(@client) }
        end
      end
    end
    ```

    -> Fetches the client record from the database based on the ID from the URL.
    -> This method tells Rails to respond differently based on the requested format.
    -> If the user visits /clients/1, Rails will render the default show.html.erb.
    -> If the user visits /clients/1.pdf, Rails will: Generate a PDF file for the client.
    -> Render it as a response to be downloaded or viewed in the browser.


    -> The user can request a PDF version of a client's details by simply adding .pdf to the URL:

    ```
    GET /clients/1.pdf
    ```

    -> If they visit /clients/1, they see an HTML page.
    -> If they visit /clients/1.pdf, they get a PDF file.



    ```
    Mime::Type.lookup_by_extension(:pdf)
    # => "application/pdf"
    ```

    -> Rails knows how to handle common file types like text/html and application/pdf using MIME
       types.
    -> This lets Rails automatically choose the right response format when the user requests .pdf.




    -> If you need additional formats (like RTF), you can register a new MIME type in config/initializers/mime_types.rb:

    ```
    Mime::Type.register("application/rtf", :rtf)
    ```

    -> Now, Rails will recognize .rtf in the URL (/clients/1.rtf).




  ## 5.3 Live Streaming of Arbitrary Data -*-*-*-*

    -> Rails provides live streaming capabilities using the ActionController::Live module. 
    -> This allows the server to send data to the client in real-time over a persistent connection
       without waiting for the entire response to be generated.
    
    ```
    class MyController < ActionController::Base
      include ActionController::Live

      def stream
        response.headers["Content-Type"] = "text/event-stream"
        100.times {
          response.stream.write "hello world\n"
          sleep 1
        }
      ensure
        response.stream.close
      end
    end
    ```

    -> Here, the server sends "hello world" every second for 100 seconds. 
    -> The browser will receive this data in real-time instead of waiting for the full response.



    ### 5.3.1 Example Use Case ----

      -> Imagine we're building a karaoke app, and we want to send song lyrics one line at a time,
         as they are sung.

      ```
      class LyricsController < ActionController::Base
        include ActionController::Live

        def show
          response.headers["Content-Type"] = "text/event-stream"
          response.headers["Cache-Control"] = "no-cache"

          song = Song.find(params[:id])

          song.each do |line|
            response.stream.write line.lyrics
            sleep line.num_beats
          end
        ensure
          response.stream.close
        end
      end
      ```

      -> This will send each line of the song in real-time, making it feel like a live karaoke
         experience
      
    
    ### 5.3.2 Streaming Considerations ----

      -> Each stream runs in a new thread
      -> Too many active streams can slow down the server.
      -> Keep track of active streams to prevent performance issues.
      -> Always close the stream (response.stream.close)
      -> If you forget to close the stream, the socket will remain open forever, consuming server
         resources.
      -> Not all servers support streaming
      -> WEBrick (Rails' default server) does not support live streaming because it buffers  
         responses.





# 6 Log Filtering */*/*/*

  -> Rails provides log filtering to prevent sensitive information from being exposed in log
     files, which is especially important in production environments.
  

  ## 6.1 Parameter Filtering -*-*-*-*

    -> By default, Rails logs every request, including parameters like form inputs and query
       strings. 
    -> However, some parameters should not be stored in logs.

    -> We can configure filter_parameters in config/application.rb to prevent sensitive data from
       appearing in logs.

    ```
    config.filter_parameters << :password
    ```
    -> [FILTERED] replaces the actual password, ensuring security.

    
    -> Partial Matching for Filtering
    -> The filter works with partial matching, so if you specify :passw, it will automatically 
       filter:
       > password
       > password_confirmation
       > user_passw

  
  ## 6.2 Redirects Filtering -*-*-*-*

    -> Sometimes, wemight want to filter sensitive URLs when logging redirects.

    -> For filter redirects we can use filter_redirect in config/application.rb.

    ```
    config.filter_redirect << "s3.amazonaws.com"
    ```
    
    -> Now, if a redirect happens to https://s3.amazonaws.com/private_file, Rails will log:

    ```
    Redirected to [FILTERED]
    ```

    -> Filtering Multiple URLs with Regular Expressions
    ```
    config.filter_redirect.concat ["s3.amazonaws.com", /private_path/]
    ```

    -> s3.amazonaws.com → Filters any AWS S3 URL
    -> /private_path/ → Filters any URL containing "private_path"
    -> If we only want to filter query parameters (not the entire URL), use parameter filtering
       instead. 





# 7 Force HTTPS Protocol */*/*/*
  
  -> By default, Rails allows both HTTP and HTTPS traffic. 
  -> However, in production, we should force all requests to use HTTPS to keep communication
     secure and encrypted.
  
  -> When you enable config.force_ssl = true, Rails does the following:

    -> Redirects all HTTP requests to HTTPS
    -> If a user tries to visit http://example.com, they will be redirected to https://example.com.
    -> Sets the Secure flag for cookies
    -> Cookies will only be sent over HTTPS, preventing session hijacking.
    -> Adds HSTS (HTTP Strict Transport Security) header
    -> Browsers will remember that our site should always use HTTPS, even if a user types http://.



  --> Why Use force_ssl?

    -> Prevents Man-in-the-Middle (MITM) attacks
    -> Encrypts all communication, protects passwords, session cookies, API calls
    -> Boosts SEO rankings
    -> Prevents mixed-content warnings, ensures all assets load securely
  





# 8 Built-in Health Check Endpoint */*/*/*

  -> Rails provides a built-in health check at the /up path. 
  -> This is useful for monitoring whether our application is running properly.


  -> Why is /up Useful?
    > Health Monitoring → Used by load balancers, Kubernetes, AWS, uptime monitors
    > Simple and Built-in → No extra setup needed for basic usage
    > Quick Status Check → Ensure your Rails app has booted correctly

  
  -> By default, the health check is at /up. 
  -> we can change the path by updating config/routes.rb

  ```
  Rails.application.routes.draw do
    get "health" => "rails/health#show", as: :rails_health_check
  end
  ```

  -> Now, the health check will be available at:
  ```
  GET /health
  ```




# 9 Handling Errors */*/*/*

  -> When something goes wrong in a Rails app. Rails automatically handles the exception and shows
     an error page
  

  -> In Development Mode if an error occurs, Rails shows a detailed error page with a stack trace,
     request details, and debugging information.
  -> This helps developers quickly identify and fix issues.

  -> In Production Mode Rails hides sensitive details and shows generic error pages:
    > 500 Internal Server Error → When an unknown error happens.
    > 404 Not Found → If a requested resource does not exist.
  -> This is done for security reasons, so users don’t see system details.



  ## 9.1 The Default Error Templates -*-*-*-*

    -> Rails uses static HTML pages located in the /public folder:
      > 404.html → Shown when a resource is not found.
      > 500.html → Shown when an internal server error occurs.
    
    -> we can edit these files to provide a better user experience by adding custom messages or 
       designs.

  

  ## 9.2 rescue_from -*-*-*-*

    -> Rails provides a powerful way to handle specific exceptions using the rescue_from method.
    -> This allows you to catch and process errors at the controller level, rather than letting 
       Rails display the default error pages.
    
    -> It intercepts exceptions before they reach Rails' default error handling.
    -> It allows custom error handling for specific errors.
    -> It applies to the controller where it's defined and all its subclasses.

    -> Whenever an exception occurs, Rails checks if there is a rescue_from directive for that
       exception.
    -> If no rescue_from is found, Rails will display a default 404 or 500 error page.
    -> If a rescue_from handler is defined, it will execute the specified method instead.

    ```
    class ApplicationController < ActionController::Base
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      private
        def record_not_found
          render plain: "Record Not Found", status: 404
        end
    end
    ```

    -> If ActiveRecord::RecordNotFound is raised, the method record_not_found will be called.
    -> Instead of Rails' default 404 page, the user will see "Record Not Found" as plain text.
    -> The HTTP response code is set to 404 (Not Found).



    ```
    class ApplicationController < ActionController::Base
      rescue_from User::NotAuthorized, with: :user_not_authorized

      private
        def user_not_authorized
          flash[:error] = "You don't have access to this section."
          redirect_back(fallback_location: root_path)
        end
    end

    class ClientsController < ApplicationController
      # Check that the user has the right authorization to access clients.
      before_action :check_authorization

      def edit
        @client = Client.find(params[:id])
      end

      private
        # If the user is not authorized, throw the custom exception.
        def check_authorization
          raise User::NotAuthorized unless current_user.admin?
        end
    end

    ```

    -> If ActiveRecord::RecordNotFound is raised, the method record_not_found will be called.
    -> Instead of Rails' default 404 page, the user will see "Record Not Found" as plain text.
    -> The HTTP response code is set to 404 (Not Found).

    -> Before an action runs, check_authorization ensures the user is an admin.
    -> If the user is not an admin, it raises User::NotAuthorized.
    -> The rescue_from directive catches this exception and calls user_not_authorized.
    -> Instead of a 500 error, the user is redirected back with an error message.















