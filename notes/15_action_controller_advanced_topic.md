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








