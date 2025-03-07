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

    













