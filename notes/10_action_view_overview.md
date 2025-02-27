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




# 4 Partials */*/*/*/*

    -> Partials in Rails allow you to break down large view templates into smaller, reusable
       pieces. 
    -> This helps in keeping our views DRY (Don't Repeat Yourself) and makes them easier to manage.

    ## 4.1 Rendering Partials ----

        -> A partial is just a smaller view template that is meant to be included inside another
           template.
        -> By convention, partial file names start with an underscore (_), but when rendering
           them, we do not use the underscore.

        -> If we have a partial file '_product.html.erb' inside 'app/views/products/', we can
           render it like 
        ```
        <%= render "product" %>
        ```
        -> This will include the contents of '_product.html.erb' inside the current view.

        -> If our partial is in another folder (e.g., app/views/application/), we reference it
           like this:
        ```
        <%= render "application/product" %>
        ```
        -> This will include '_product.html.erb 'from 'app/views/application/'.

    
    ## 4.2 Using Partials to Simplify Views ----

        -> Partials can be used to simplify views by breaking them into logical sections.

        -> Suppose you have a products/index.html.erb view like this:
        ```
        <%= render "application/ad_banner" %> <!-- Shared banner -->

        <h1>Products</h1>

        <p>Here are a few of our fine products:</p>

        <% @products.each do |product| %>
        <%= render partial: "product", locals: { product: product } %>
        <% end %>

        <%= render "application/footer" %> <!-- Shared footer -->
        ```

        -> '_ad_banner.html.erb' and '_footer.html.erb' are shared partials, used in multiple
           pages.
        -> '_product.html.erb' is used to display each product from '@products'.

    
    
    ## 4.3 Passing Data to Partials with locals Option ----

        -> Imagine we have a Products page where we display product details. 
        -> Instead of writing all the HTML inside 'show.html.erb', we extract it into a partial.

        ```
        <%= render partial: "product", locals: { my_product: @product } %>
        ```
        -> We pass '@product' from the main view to the '_product.html.erb' partial.
        -> Inside the partial, it will be available as 'my_product'.


        --> Use the Local Variable in the Partial In app/views/products/_product.html.erb:

        ```
        <%= tag.div id: dom_id(my_product) do %>
            <h1><%= my_product.name %></h1>
            <p>Price: $<%= my_product.price %></p>
        <% end %>
        ```

        -> The variable '@product' is not automatically available inside the partial.
        -> We pass it as 'my_product', making it local to the partial.

    
    ## 4.4 Using local_assigns ----

        -> local_assigns is a special hash available inside partials that stores the keys and
           values passed via 'locals:'.
        -> If a key is not passed, 'local_assigns[:key]' will return nil.


        ```
        <%# app/views/products/show.html.erb %>

        <%= render partial: "product", locals: { product: @product } %>
        ```
        -> Here, only product is passed to the partial.

        ```
        <%# app/views/products/_product.html.erb %>

        <% local_assigns[:product]          # => "#<Product:0x0000000109ec5d10>" %>
        <% local_assigns[:product_reviews]  # => nil %>

        ```
        -> local_assigns[:product] contains the product.
        -> local_assigns[:product_reviews] is nil because it wasn’t passed.


        -> In _form.html.erb, we check local_assigns[:redirect]:
        ```
        <% if local_assigns[:redirect] %>
            <%= form.hidden_field :redirect, value: true %>
        <% end %>
        ```

        -> If redirect was passed, we add a hidden field.
        -> If not, the field is not included.


    
    ## 4.5 render without partial and locals Options ----

        -> In above examples we used render like this:
        ```
        <%= render partial: "product", locals: { product: @product } %>
        ```
        -> However, Rails allows shorthand syntax to make views cleaner and more readable.

        --> Instead of explicitly writing, we can simplify it:
        ```
        <%= render "product", product: @product %>
        ```
        -> "product" → Refers to the partial file _product.html.erb
        -> product: @product → Passes @product as a local variable product


        -> If we're rendering a single ActiveRecord object, Rails automatically:
            -> Finds the corresponding partial
            -> Passes the object as a local variable
        
        ```
        <%= render @product %>
        ```
        -> Rails convention: If @product is an instance of Product, it looks for _product.html.erb.
        -> The object (@product) is automatically available inside the partial as product.


    ## 4.6 The as and object Options---

        -> By default, objects passed to to the template are in local variable with the same name
           as template.
        ```
        <%= render @product %>
        ```
        
        -> within the _blog_post.html.erb partial we'll get @post instance variable in the local
           variable post.
        
        ```
        <%= render partial: "blog_post", locals: { post: @post } %>
        ```


        -> we can used the 'object' option to specify a different name.
        -> This is usefull when the object in different location.

        -> for exmaple instead of 
        ```
        <%= render partial: "blog_post", locals: { post: @post } %>
        ```
        -> We can simply write:
        ```
        <%= render partial: "blog_post", object: @post %>
        ```

        -> This assign the instance variable @post to a partial local variable named 'post'.
        -> If we want to change the local variable name form default post to something else
           for that we can simply use ':as' option for that
        
        ```
        <%= render partial: "blog_post", object: @post, as: "post" %>
        ```

        -> This is similar to: 
        ```
        <%= render partial: "blog_post", locals: { post: @post } %>
        ```
        
    
    ### 4.7 Rendering Collections ----
        
        -> Rendering collections is a way to iterate over multiple records and render a partial
           for each item automatically. 
        -> Instead of manually looping with <% @items.each do |item| %>, Rails provides a cleaner
           and more efficient way to render collections.

        -> for Example rendering all the product
        ```
        <% @products.each do |product| %>
            <%= render partial: "blog_post", locals: { blog_post: blog_post } %>
        <% end %>
        ```

        -> we can rewrite this in a single line like this:
        ```
        <%= render partial: "blog_post", collection: @blog_post %>
        ```

    

    ### 4.8 Spacer Templates ----

        -> Spacer templates allow you to insert a second partial between items in a collection
           when rendering. 
        -> This is useful for adding dividers, separators, or spacing elements between rendered
           elements.

        ```
        <%= render partial: @blog_posts, spacer_template: "blog_post_separator" %>
        ```

        -> Render _blog_post.html.erb for each @blog_post.
        -> Insert _blog_post_separator.html.erb between each blog post.


    ## 4.9 Counter Variables ---

        -> When rendering a collection using a partial, Rails automatically provides a counter
           variable that keeps track of how many times the partial has been rendered.
        
        -> If we are rendering multiple blog posts using a collection, we can use a counter
           variable to display post numbers, alternate styles, or even odd/even row coloring.
        
        ```
        <%= render partial: "blog_post", collection: @blog_posts %>
        ```

        -> This will Render _blog_post.html.erb for each @blog_post
        -> Assign a counter variable blog_post_counter that starts from 0 and increments with 
           each iteration.
        
   
	

	## 4.10 local_assigns with Pattern Matching ----

		-> local_assigns is a special Hash available in Rails partials that contains all the local 
		   variables passed to the partial when rendering it. 
		-> With Ruby 3.1, you can use pattern matching assignment to unpack local_assigns more elegantly.

		#-> Basic pattern matching in local_assigns

		-> instead of manually accessing values from local_assigns we can use pattern matching
		```
		<% local_assigns => { product:, **options } %>
		```

		-> product: extracts the product key from local_assigns.
		-> **options collects all remaining keys into the options Hash.


		```
		<%# app/views/products/_product.html.erb %>

		<% local_assigns => { product:, **options } %>

		<%= tag.div id: dom_id(product), **options do %>
		<h1><%= product.name %></h1>
		<% end %>

		<%# app/views/products/show.html.erb %>

		<%= render "products/product", product: @product, class: "card" %>
		<%# => <div id="product_1" class="card">
		#      <h1>A widget</h1>
		#    </div>
		%>
		```


		#-> Variable Renaming with Pattern Matching
		
		-> we can rename extracted variables:
		```
		<% local_assigns => { product: record } %>
		```

		-> now product is available as record as well.
		-> product == record will return true.


		#-> Providing Default Values with fetch

		-> If a local variable isn't passed, we can provide a default value using fetch:
		```
		<% local_assigns.fetch(:related_products, []).each do |related_product| %>
			<%# Process related_product %>
		<% end %>
		```
		
		-> If related_products isn't passed, it defaults to an empty array ([]).
		-> This prevents errors when iterating.


		#-> Compact Default Assignments with with_defaults

		-> Instead of calling fetch multiple times, you can use with_defaults to assign default values in a cleaner way:

		```
		<% local_assigns.with_defaults(related_products: []) => { product:, related_products: } %>
		```

		-> This ensures:
			-> related_products is always an array (avoiding nil errors).
			-> The code remains concise and readable.



	## 4.11 Strict Locals ---

		-> In Rails, partials are compiled into Ruby methods, and each unique combination of 
		   local variables passed to a partial results in a separate compiled method. 
		-> This can lead to performance issues when multiple variations of locals are used.
		-> To optimize memory usage and reduce compilation overhead, strict locals allow us to
		   explicitly define which local variables a partial accepts and set default values.
		

		```
		<%= render partial: "article", layout: "box", locals: { article: @article } %>
		<%= render partial: "article", layout: "box", locals: { article: @article, theme: "dark" } %>
		```

		-> Each unique combination of locals causes Rails to compile a new method:
		
		```
		def _render_template_2323231_article_show(buffer, local_assigns, article:)
		# ...
		end

		def _render_template_3243454_article_show(buffer, local_assigns, article:, theme:)
		# ...
		end
		```

		-> If many variations exist, this wastes memory and CPU time.

		-> By defining a strict locals signature, we tell Rails that only certain locals are
		   valid, preventing unnecessary method recompilation.
		
		```
		<%# locals: (article:, theme: "light") -%>
		```
		-> This means: article: is required, theme: has a default value of "light".
		-> Now, regardless of whether theme: is passed or not, only one compiled method is used.


		-> If a local variable is marked without a default value, it is required.
		```
		<%# locals: (message:) -%>
		<%= message %>
		```

		-> Rendering this without passing message causes an error:
		```
		render "messages/message"
		# => ActionView::Template::Error: missing local: :message
		```

		-> Setting a default value makes the local optional:
		```
		<%# locals: (message: "Hello, world!") -%>
		<%= message %>
		```

		-> If message: is not passed, "Hello, world!" is used.
		```
		render "messages/message"
		# => "Hello, world!"
		```

		-> If you pass an unknown local that isn’t in locals:, Rails raises an error.
		```
		render "messages/message", unknown_local: "will raise"
		# => ActionView::Template::Error: unknown local: :unknown_local
		```

		-> Handling Reserved Ruby Keywords:
			-> Some Ruby keywords (like class or if) cannot be used as variable names. 
			-> If you must use them, access them via binding.local_variable_get
		
		```
		<%# locals: (class: "message") %>
		<div class="<%= binding.local_variable_get(:class) %>">...</div>
		```



# 5 Layouts */*/*/*/*

	-> Layouts in Rails are templates that wrap around views, providing a consistent structure 
	   for multiple pages. 
	-> They typically contain common elements like:
		-> Navigation bar
		-> Header & Footer
		-> Meta tags & stylesheets
	
	-> Instead of repeating the same structure in every view, layouts use yield to insert the
	   unique content of each page dynamically.
	
	-> By default, Rails looks for a layout file that matches the controller name. 
	-> If a specific layout isn't found, it falls back to application.html.erb.

	```
	<!DOCTYPE html>
	<html>
	<head>
	<title><%= "Your Rails App" %></title>
	<%= csrf_meta_tags %>
	<%= csp_meta_tag %>
	<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
	<%= javascript_importmap_tags %>
	</head>
	<body>

	<nav>
	<ul>
		<li><%= link_to "Home", root_path %></li>
		<li><%= link_to "Products", products_path %></li>
		<!-- Additional navigation links here -->
	</ul>
	</nav>

	<%= yield %>

	<footer>
	<p>&copy; <%= Date.current.year %> Your Company</p>
	</footer>

	```



	## 5.1 Partial Layouts----

		-> Partial layouts in Rails wrap around a partial view, similar to how a regular layout
		   wraps around a full page.
		-> They help in reusing common structures across different parts of an application.

		-> Key Difference:
			-> Application layouts wrap full views (e.g., application.html.erb).
			-> Partial layouts wrap only specific partials (e.g., _blog_post.html.erb).

		-> Let's assume we have a BlogPost with some content:
		```
		BlogPost.create(title: "Rails Partials", body: "Partial Layouts are very useful!")
		```

		-> Now, in the show page, we render the blog post inside the box layout:
		```
		<%= render partial: "blog_post", layout: "box", locals: { blog_post: @blog_post } %>
		```

		-> partial: "blog_post" → Loads _blog_post.html.erb
		-> layout: "box" → Wraps it inside _box.html.erb
		-> locals: { blog_post: @blog_post } → Passes @blog_post to the partial


		-> Instead of using a separate _blog_post.html.erb partial, we can directly write 
		   the HTML inside the render block:

		```
		<%= render(layout: "box", locals: { blog_post: @blog_post }) do %>
			<div>
				<h2><%= blog_post.title %></h2>
				<p><%= blog_post.body %></p>
			</div>
		<% end %>
		```

		-> This produces the same output but without a separate _blog_post.html.erb file.



	### 5.2 Collection with Partial Layouts ---

		-> Rails allows rendering multiple blog posts with a partial layout for each.

		```
		<%= render partial: "blog_post", collection: @blog_posts, layout: "box" %>
		```

		-> This will wrap each blog post inside _box.html.erb.
		-> The blog_post and blog_post_counter variables will be available inside 
		   _blog_post.html.erb.


# 6 Helpers */*/*/*

	-> Helpers in Rails are utility methods that assist in formatting, generating HTML, sanitizing
	   input, creating forms, and localizing content inside views. 
	-> They help keep views clean and follow the DRY (Don't Repeat Yourself) principle.

	--> Common Uses of Helpers: 
		-> Formatting dates, strings and numbers
		-> Creating HTML links to images, videos, stylesheets, etc...
		-> Sanitizing content
		-> Creating forms
		-> Localizing content


# 7 Localized Views */*/*/*

	-> Rails supports multiple languages by automatically selecting different view templates 
	   based on the user's locale.
	
	-> For example:
	-> Default template: app/views/blog_post/show.html.erb
	-> localized template: app/views/blog_post/show.de.html.erb

	-> When the locale is set to German (:de), Rails will first try to render show.de.html.erb. 
	-> If it’s not available, it will fall back to show.html.erb.

	-> Localized views allow Rails to display different templates based on the user's language
	   preference.
	-> If a localized version of a view is not available, Rails falls back to the default template.
































