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

         

















