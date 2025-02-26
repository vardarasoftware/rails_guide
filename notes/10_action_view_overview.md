#### */*/*/* Action View Overview */*/*/*/*

# 1 What is Action View? */*/*/*

    -> Action View is a part of the MVC (Model-View-Controller) framework in Rails. 
    -> It handles the "View" part, which means it is responsible for displaying what the user sees
       on the website.
    -> When a user makes a request, the Action Controller fetches the necessary data from the
       Model. 
    -> After getting the data, the controller sends it to Action View, which takes care of showing
       that data on the webpage.
    -> By default, Action View uses ERB (Embedded Ruby), which allows us to mix Ruby code with 
       HTML. 
    -> This makes it possible to display dynamic content, like showing a user’s name or a list of
       items from the database.
    -> Action View also provides helper methods that make it easier to create common HTML 
       elements, like forms, date pickers, and formatted text. 
    -> If needed, developers can also create their own custom helpers to simplify repetitive tasks.
    -> In short, Action View turns data into a user-friendly webpage, making it an essential part 
       of how Rails applications display information.


# 2 Using Action View with Rails */*/*/*
    
    -> In a Rails application, Action View templates are stored inside the app/views folder. 
    -> Each controller has its own subfolder inside app/views, where the related view files are
       kept.
    
    -> When you create a controller, Rails automatically creates a matching folder inside 
       app/views/, named after the controller.
    -> Each view file inside that folder corresponds to a specific controller action.
    -> These view files are written using ERB ".html.erb", which lets us mix Ruby code with HTML
       to create dynamic web pages.
    
    -> If we generate an Article resource using scaffolding "bin/rails generate scaffold article",
       Rails automatically creates:
       ```
        [...]
      invoke  scaffold_controller
      create    app/controllers/articles_controller.rb
      invoke    erb
      create      app/views/articles
      create      app/views/articles/index.html.erb
      create      app/views/articles/edit.html.erb
      create      app/views/articles/show.html.erb
      create      app/views/articles/new.html.erb
      create      app/views/articles/_form.html.erb
      [...]
      
      ````

    -> Naming Convection 

        -> The view file must match the controller action’s name.
        -> For example, the index action in ArticlesController will automatically render app/views/
           articles/index.html.erb, without needing to specify it.
        -> If we follow this naming and folder structure, Rails knows which view to display for 
           each action.
    
    -> Output
        -> When a request is made, Rails combines:
        -> The ERB view file (e.g., index.html.erb)
        -> A layout template (a wrapper around the view, usually found in app/views/layouts/)
        -> Any partials (small reusable pieces of a view, like _form.html.erb)
        -> This combination produces the final HTML that is sent to the user's browser.



# 3 Templates */*/*/*

    -> In Rails, Action View templates define how the response should be formatted. 
    -> These templates can be written in different formats depending on the required output type.

    -> Types of Template Formats

        -> ERB (.html.erb) → Generates HTML using Embedded Ruby (ERB).
        -> Jbuilder (.json.jbuilder) → Generates JSON using the Jbuilder gem.
        -> Builder (.xml.builder) → Generates XML using the Builder::XmlMarkup library.
    -> Rails automatically selects the correct template based on the file extension.


    ## 3.1 ERB ----

        -> ERB (Embedded Ruby) is the default template system in Rails. It allows you to mix Ruby
           code inside HTML.
        -> ERB uses two types of tags:
            🔹 <% %> → Executes Ruby code (but doesn’t output it)
            -> Used for conditions, loops, or any Ruby logic without displaying output.

            🔹 <%= %> → Executes Ruby code and outputs it
            -> Used when you want to display data in the template.
        
        ```
        <h1>Names</h1>
        <% @people.each do |person| %>
        Name: <%= person.name %><br>
        <% end %>
        ```

        -> The loop <% @people.each do |person| %> iterates over each person.
        -> The <%= person.name %> displays each person’s name inside HTML.


        -> Functions like puts and print won’t work because ERB is designed to insert values into
           HTML, not print to the console.
        ```
        <%# WRONG %>
        Hi, Mr. <% puts "Frodo" %>
        ```
        -> This won’t work because puts prints to the console, not the view.

        
    
    ## 3.2 Jbuilder ----

        -> Jbuilder is a built-in Rails gem used to generate JSON responses in a structured way.
        
        -> Why use Jbuilder?
            -> Helps format JSON responses cleanly.
            -> Keeps API response logic inside views, not controllers.
            -> Provides better control over JSON structure.
        
        -> Jbuilder comes with Rails by default, but if it's missing, add this to your Gemfile and
           run bundle install:
        ```
        gem "jbuilder"
        ```

        -> Example for josn 

        ```
        json.name("Alex")
        json.email("alex@example.com")
        ```

        -> The Output for the example is:
        ```
        {
        "name": "Alex",
        "email": "alex@example.com"
        }

        ```


    ## 3.3 Builder ----

        -> Builder is a template engine similar to Jbuilder but used for generating XML.

        -> Why use Builder?
            -> Used when APIs need XML responses.
            -> Makes XML generation programmatic.

        -> Basic Example:
        ```
        xml.em("emphasized")
        xml.em { xml.b("emph & bold") }
        xml.a("A Link", "href" => "https://rubyonrails.org")
        xml.target("name" => "compile", "option" => "fast")
        ```

        -> Output of XML Responce:
        ```
        <em>emphasized</em>
        <em><b>emph &amp; bold</b></em>
        <a href="https://rubyonrails.org">A link</a>
        <target option="fast" name="compile" />
        ```

    
    ## 3.4 Template Compilation ---

        -> Rails compiles templates into methods for efficiency.

        -> In Development Mode: Rails checks file modifications and recompiles templates when
           needed.
        -> In Production Mode: Templates are compiled once and cached for performance.















