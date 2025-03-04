### */*/*/*/*  Action View Helpers  */*/*/*/*

# 1 Formatting */*/*/*/*

  ## 1.1 Dates ----

    ### 1.1.1 distance_of_time_in_words

      -> This helper returns an approximate time difference between two time values.

      ```
      distance_of_time_in_words(Time.current, 15.seconds.from_now)
      # Output: "less than a minute"
      ```
      -> Time.current gives the current time.
      -> 15.seconds.from_now adds 15 seconds to the current time.
      -> The method calculates the difference and formats it as a readable string.
      -> Since include_seconds is not set, it rounds the value and returns "less than a minute".

      ```
      distance_of_time_in_words(Time.current, 15.seconds.from_now, include_seconds: true)
      # Output: "less than 20 seconds"
      ```

      -> The include_seconds: true option gives a more precise result when the time difference is
         small.
      
      -> Why Time.current instead of Time.now?
        -> Time.current respects the Rails application's timezone settings.
        -> Time.now uses the system (server) timezone, which can cause inconsistencies in
           different environments.
    

    ### 1.1.2 time_ago_in_words

      -> This is a shortcut for distance_of_time_in_words. 
      -> It calculates how much time has passed from now to the given time.

      ```
      time_ago_in_words(3.minutes.from_now) 
      # Output: "3 minutes"
      ``` 

      -> 3.minutes.from_now is a future time.
      -> The helper calculates the difference and formats it.
      -> If the time were in the past, it would return "3 minutes ago" when used with 
         #{time_ago_in_words(time)} ago.
      
  
  ## 1.2 Numbers -----

    -> These methods are part of ActionView’s NumberHelper in Rails. 
    -> They help format numbers into user-friendly strings.

    ### 1.2.1 number_to_currency

      -> Formats a number into currency format (default: US dollars).
      -> It adds commas for thousands and rounds to two decimal places.

      ```
      number_to_currency(1234567890.50) 
      # => "$1,234,567,890.50"
      ```

      -> we can change the currency symbol, decimal places, etc.



    ### 1.2.2 number_to_human

      -> Formats large numbers into readable words (thousands, millions, billions, etc.).
      -> Useful when showing big numbers in a compact format.

      ```
      number_to_human(1234)    
      # => "1.23 Thousand"

      number_to_human(1234567) 
      # => "1.23 Million"
      ```
      -> we can change the precision or disable rounding.



    ### 1.2.3 number_to_human_size

      -> Formats bytes into readable file sizes (KB, MB, GB, etc.).
      -> Used for displaying file sizes in human-readable format.

      ```
      number_to_human_size(1234)    
      # => "1.21 KB"

      number_to_human_size(1234567) 
      # => "1.18 MB"
      ```
      -> we can specify how precise the rounding should be.



    ### 1.2.4 number_to_percentage

      -> Formats a number as a percentage.

      ```
      number_to_percentage(100, precision: 0) 
      # => "100%"
      ```
      -> we can control the number of decimal places.


    ### 1.2.5 number_to_phone

      -> Formats a number as a US phone number.
      ```
      number_to_phone(1235551234)
      # => "123-555-1234"
      ```

      -> Customization: we can add country codes, extensions, and formatting.

    
    ### 1.2.6 number_with_delimiter

      -> Adds thousands separators (commas by default).
      ```
      number_with_delimiter(12345678) 
      # => "12,345,678"
      ```

      -> Customization: we can change the delimiter (e.g., using dots for European formats).



    ### 1.2.7 number_with_precision

      -> Rounds a number to a specific decimal place.
      ```
      number_with_precision(111.2345) 
      # => "111.235"

      number_with_precision(111.2345, precision: 2) 
      # => "111.23"
      ```

      -> Useful when we need a fixed number of decimals for consistency.


  ## 1.3 Text -----

    -> These methods are part of ActionView’s TextHelper in Rails. 
    -> They help in formatting and manipulating text.


    ### 1.3.1 excerpt

      -> Finds a phrase in a text and extracts a portion around it.
      -> Useful for highlighting search results or showing relevant context.
      -> If the extracted text is incomplete, an ellipsis (...) or a custom marker is added.

      ```
      excerpt("This is a very beautiful morning", "very", separator: " ", radius: 1)
      # => "...a very beautiful..."
      ```

      -> Searches for "very" in the string.
      -> Extracts 1 word before and 1 word after (radius: 1).
      -> Adds "..." because the extracted text doesn’t start from the beginning.


    ### 1.3.2 pluralize

      -> Automatically chooses singular or plural based on a number.
      -> Useful for displaying item counts in a user-friendly way.
      
      ```
      pluralize(1, "person") 
      # => "1 person"

      pluralize(2, "person") 
      # => "2 people"
      ```

      -> If the number is 1, the singular form is used ("person").
      -> If the number is greater than 1, the plural form is used ("people" - irregular plural).

      
      
      #-> Custom Pluralization:

      ```
      pluralize(3, "person", plural: "users")
      # => "3 users"
      ```

      -> Normally "people" would be used, but we override it with "users".


    ### 1.3.3 truncate

      -> Shortens a string to a specific length.
      -> Adds an omission marker (... by default) if the text is cut off.
      -> Useful for displaying previews of long content.

      ```
      truncate("Once upon a time in a world far far away")
      # => "Once upon a time in a world..."
      ```

      -> Default length is 30 characters.
      -> "..." is added if the text is too long.

      #-> Custom Length:

      ```
      truncate("Once upon a time in a world far far away", length: 17)
      # => "Once upon a ti..."
      ```

      -> Only 17 characters are shown.

      
      #-> Using a Custom Omission Marker:

      ```
      truncate("And they found that many people were sleeping better.", length: 25, omission: "... (continued)")
      # => "And they f... (continued)"
      ```
      -> Instead of "...", custom text is used.


      #-> Using a Separator (- instead of cutting in the middle of a word):

      ```
      truncate("one-two-three-four-five", length: 20, separator: "-")
      # => "one-two-three..."
      ```

      -> The text is cut at a hyphen (-) instead of breaking a word.


      #-> Preserving HTML Tags:

      ```
      truncate("<p>Once upon a time in a world far far away</p>", escape: false)
      # => "<p>Once upon a time in a wo..."
      ```

      -> If escape: false is used, HTML tags are preserved.

    
    ### 1.3.4 word_wrap
      
      -> Breaks a long string into multiple lines.
      -> Useful for formatting text for emails or console output.

      ```
      word_wrap("Once upon a time", line_width: 8)
      # => "Once\nupon a\ntime"
      ```

      -> The text is wrapped into lines of max 8 characters.
      -> New lines (\n) are added without breaking words unnecessarily.



# 2 Forms */*/*/*/*

  -> Rails Form Helpers make it easier to work with forms, especially when dealing with models.
  -> Instead of manually writing HTML form elements, Rails provides methods that generate the 
     appropriate form fields automatically.


  -> Why Use Form Helpers?
    > Simplifies form creation – No need to write repetitive HTML.
    > Automatically associates fields with models – Helps in saving and updating records easily.
    > Handles naming conventions – Ensures form fields are grouped properly in params.
    > Provides built-in security – Protects against CSRF (Cross-Site Request Forgery) attacks.




# 3 Navigation */*/*/*/*

  -> Rails Navigation Helpers make it easier to generate URLs and links dynamically based on 
     our application's routing system. 
  -> Instead of manually writing URLs, these helpers automatically generate correct paths based 
     on controllers, actions, and models.

  
  ## 3.1 button_to ----

    -> This method generates a form with a submit button that sends a request to the specified URL.

    ```
    <%= button_to "Sign in", sign_in_path %>
    ```

    -> Generated HTML:
    ```
    <form method="post" action="/sessions" class="button_to">
      <input type="submit" value="Sign in" />
    </form>
    ```

    -> Why use button_to instead of link_to?
      -> Useful for performing POST, DELETE, or PATCH requests.
      -> Automatically protects against CSRF attacks.
    

  
  ## 3.2 current_page? ---

    -> This method checks whether the current URL matches a given controller and action.

    ```
    <% if current_page?(controller: 'profiles', action: 'show') %>
      <strong>Currently on the profile page</strong>
    <% end %>
    ```

    -> When to use it?
      -> Highlight the current page in navigation menus.
      -> Show a different UI when a user is on a specific page.

  

  ## 3.3 link_to ---

    -> Generates a clickable hyperlink (<a> tag) to a given URL.

    ```
    <%= link_to "Profile", @profile %>
    ```

    -> Generated HTML:
    ```
    <a href="/profiles/1">Profile</a>
    ```


    -> link_to "Profiles", profiles_path
    
    ```
    # => <a href="/profiles">Profiles</a>

    link_to "Articles", articles_path, class: "article__container", id: "articles"
    # => <a href="/articles" class="article__container" id="articles">Articles</a>

    link_to "Visit Google", "https://google.com"
    # => <a href="https://google.com">Visit Google</a>
    ```

    -> Advantages of link_to:
      -> Automatically generates the correct URL.
      -> Supports CSS classes, HTML attributes, and dynamic paths.
    
    -> Using a Block
    
    ```
    <%= link_to @profile do %>
      <strong><%= @profile.name %></strong> -- <span>Check it out!</span>
    <% end %>
    ```

    -> Generated HTML:

    ```
    <a href="/profiles/1">
      <strong>David</strong> -- <span>Check it out!</span>
    </a>
    ```

    -> Why use the block syntax? ---> Allows for more complex link content.

  
  
  ## 3.4 mail_to ---

    -> Creates an email link (mailto:) so users can click to send an email.

    ```
    <%= mail_to "john_doe@gmail.com" %>
    ```

    -> Generated HTML:
    ```
    <a href="mailto:john_doe@gmail.com">john_doe@gmail.com</a>
    ```


    -> With Subject & CC:

    ```
    mail_to "me@john_doe.com", cc: "me@jane_doe.com", subject: "Hello!"
    ```

    -> Generated HTML:

    ```
    <a href="mailto:me@john_doe.com?cc=me@jane_doe.com&subject=Hello!">me@john_doe.com</a>
    ```

    -> Why use mail_to?
      -> Automatically encodes emails to prevent spam bots from scraping addresses.
      -> Supports custom subjects, CC, and BCC.



  ## 3.5 url_for ---

    -> Generates a URL string for a given model, controller, or set of parameters.

    ```
    url_for(@profile)
    ```

    -> Output:
    ```
    /profiles/1
    ```

    -> With Nested Resources:

    ```
    url_for([@hotel, @booking, page: 2, line: 3])
    ```

    -> Output:
    ```
    /hotels/1/bookings/1?line=3&page=2
    ```

    -> Why use url_for?
      -> Used when you only need the URL, not a clickable link.
      -> Great for APIs, redirects, and dynamic path generation.



# 4 Sanitization */*/*/*

  -> Sanitization in Rails helps remove unwanted or potentially dangerous HTML/CSS from user input
     before displaying it in views. 
  -> This prevents Cross-Site Scripting (XSS) attacks and ensures that only safe content is shown.


  ## 4.1 sanitize ----

    -> The sanitize method removes all disallowed HTML tags and attributes from the input.

    ```
    <%= sanitize @article.body %>
    ```

    -> If @article.body contains:
    ```
    <script>alert("Hacked!");</script> <b>Bold Text</b>
    ```
    
    -> Output:
    ```
    <b>Bold Text</b>
    ```

    -> Result: <script> tag is removed, but <b> is allowed.
  

  ## 4.2 sanitize_css ----

    -> Used to remove unsafe styles from user-generated CSS.

    ```
    sanitize_css("background-color: red; color: white; font-size: 16px;")
    ```

    -> If sanitize_css removes any unsafe styles, only the safe ones remain.
    -> Prevents users from injecting malicious CSS, like display:none.


  
  ## 4.3 strip_links ----

    -> Removes anchor (<a>) tags but keeps the link text.

    -> Example: Remove Links but Keep Text
    ```
    <%= strip_links("<a href='https://rubyonrails.org'>Ruby on Rails</a>") %>
    ```

    -> Output:
    ```
    Ruby on Rails
    ```

    -> Example: Remove Email Links
    
    ```
    <%= strip_links("emails to <a href='mailto:me@email.com'>me@email.com</a>.") %>
    ```

    -> Output:
    ```
    emails to me@email.com.
    ```
    -> Useful when displaying user-generated text where links should not be clickable.



  
  ##  4.4 strip_tags ----

    -> Removes all HTML tags, leaving only plain text.

    -> Example: Strip All Tags
    ```
    <%= strip_tags("Strip <i>these</i> tags!") %>
    ```

    -> Output:
    ```
    Strip these tags!
    ```

    Example: Clean Up Malformed Links

    ```
    <%= strip_tags("<b>Bold</b> no more! <a href='more.html'>See more</a>") %>
    ```

    -> Output:  
    ```
    Bold no more! See more
    ```

    -> Use Case:
    -> When extracting plain text from rich HTML content.
    -> When preventing HTML injection attacks.




# 5 Assets */*/*/*/*/*

  -> Rails provides helper methods to easily include assets.
  -> These helpers generate correct URLs for assets, even if they are hosted on a separate asset 
     server.

  -> By default, Rails serves assets from the public folder. However, for performance and caching,
     we can use a dedicated asset server.

  -> Example: Setting Up an Asset Host
    -> In config/environments/production.rb:

  ```
  config.asset_host = "assets.example.com"
  ```

  -> Now, image_tag("rails.png") will generate:

  ```
  <img src="//assets.example.com/images/rails.png" />
  ```

  -> This improves performance by offloading assets to a CDN or separate server.


  ## 5.1 audio_tag ----

    -> Generates an <audio> tag with one or more sources.

    -> Example: Single Audio Source
    ```
    <%= audio_tag("sound") %>
    ```
    -> Output:
    ```
    <audio src="/audios/sound"></audio>
    ```

    -> Rails assumes the file is in public/audios/.

    -> Example: Multiple Audio Formats (For Browser Compatibility)
    ```
    <%= audio_tag("sound.wav", "sound.mid") %>
    ```

    -> Output:
    ```
    <audio>
      <source src="/audios/sound.wav" />
      <source src="/audios/sound.mid" />
    </audio>
    ```

    -> Example: Adding Controls
    ```
    <%= audio_tag("sound", controls: true) %>
    ```

    -> Output:
    ```
    <audio controls="controls" src="/audios/sound"></audio>
    ```
    
    -> Embed background music, podcasts, or sound effects.

  

  ## 5.2 auto_discovery_link_tag ----

    -> Generates <link> tags for RSS, Atom, or JSON feeds, allowing browsers and feed readers to
       auto-detect your site's feeds.

    -> Example: RSS Feed Link
    ```
    <%= auto_discovery_link_tag(:rss, "http://www.example.com/feed.rss", { title: "RSS Feed" }) %>
    ```

    -> Output:
    ```
    <link rel="alternate" type="application/rss+xml" title="RSS Feed" href="http://www.example.com/feed.rss" />
    ```

    -> If you have a blog or news section, browsers can automatically detect and subscribe to our 
       feed.

    
  
  ## 5.3 favicon_link_tag -----

    -> Generates a <link> tag for the favicon of your site.

    -> Example: Default Usage
    ```
    <%= favicon_link_tag %>
    ```

    -> Output:
    ```
    <link href="/assets/favicon.ico" rel="icon" type="image/x-icon" />
    ```
    
    -> Looks for favicon.ico in the assets directory.

    -> Example: Custom Favicon
    ```
    <%= favicon_link_tag "custom_icon.png" %>
    ```

    -> Output:
    ```
    <link href="/assets/custom_icon.png" rel="icon" type="image/png" />
    ```

    -> Helps users quickly recognize your website in browser tabs.

  
  ## 5.4 image_tag ----

    -> Generates an <img> tag with the correct asset path.

    -> Example: Basic Image
    ```
    <%= image_tag("icon.png") %>
    ```

    -> Output:
    ```
    <img src="/assets/icon.png" />
    ```

    -> Rails looks for icon.png in app/assets/images/.

    -> Example: Adding Size and Alt Text
    ```
    <%= image_tag("icon.png", size: "16x10", alt: "Edit Article") %>
    ```
    
    -> Output:
    ```
    <img src="/assets/icon.png" width="16" height="10" alt="Edit Article" />
    ```

    -> Displaying logos, icons, and user profile pictures.

  
  ##  5.5 javascript_include_tag ----

    -> Generates <script> tags for JavaScript files.

    -> Example: Basic JavaScript File
    ```
    <%= javascript_include_tag("common") %>
    ```

    -> Output:
    ```
    <script src="/assets/common.js"></script>
    ```

    -> Rails looks for common.js in app/assets/javascripts/.

    -> Example: Async JavaScript Loading
    ```
    <%= javascript_include_tag("common", async: true) %>
    ```

    -> Output:
    ```
    <script src="/assets/common.js" async="async"></script>
    ```

    -> async allows the script to load without blocking page rendering.
    -> Loading interactive JavaScript functionality like menus and animations.


  ## 5.6 picture_tag -----

    -> Generates a <picture> tag, allowing different image formats for different browsers.

    -> Example: Providing Multiple Image Formats
    ```
    <%= picture_tag("icon.webp", "icon.png") %>
    ```

    -> Output:
    ```
    <picture>
      <source srcset="/assets/icon.webp" type="image/webp" />
      <source srcset="/assets/icon.png" type="image/png" />
      <img src="/assets/icon.png" />
    </picture>
    ```

    -> Optimizing images for performance by providing modern formats.


  
  ## 5.7 preload_link_tag -----

    -> Helps browsers load assets early for better performance.

    -> Example: Preloading a CSS File
    ```
    <%= preload_link_tag("application.css") %>
    ```

    -> Output:
    ```
    <link rel="preload" href="/assets/application.css" as="style" type="text/css" />
    ```

    -> Ensuring critical CSS or fonts load as soon as possible.



  ## 5.8 stylesheet_link_tag -----

    -> Generates <link> tags for CSS files.

    -> Example: Basic Stylesheet Link
    ```
    <%= stylesheet_link_tag("application") %>
    ```

    -> Output:
    ```
    <link href="/assets/application.css" rel="stylesheet" />
    ```

    -> Rails looks for application.css in app/assets/stylesheets/.

    -> Example: Specifying Media Type
    ```
    <%= stylesheet_link_tag("application", media: "all") %>
    ```

    -> Output:
    ```
    <link href="/assets/application.css" media="all" rel="stylesheet" />
    ```

    -> media="all" means the CSS applies to all screen types.
    -> Styling the website with custom or external CSS.


  
  ## 5.9 video_tag ----

    -> Generates a <video> tag for videos.

    -> Example: Basic Video
    ```
    <%= video_tag("trailer") %>
    ```

    -> Output:
    ```
    <video src="/videos/trailer"></video>
    ```

    -> Rails looks for trailer in public/videos/.

    -> Example: Multiple Video Formats

    ```
    <%= video_tag(["trailer.ogg", "trailer.flv"]) %>
    ```

    -> Output:
    ```
    <video>
      <source src="/videos/trailer.ogg" />
      <source src="/videos/trailer.flv" />
    </video>
    ```

    -> Example: Adding Controls

    ```
    <%= video_tag("trailer", controls: true) %>
    ```

    -> Output:
    ```
    <video controls="controls" src="/videos/trailer"></video>
    ```

    -> Embedding tutorials, product demos, or background videos.




# 6 JavaScript */*/*/*/*

  ## 6.1 escape_javascript ------

    -> This method is used to escape special characters in JavaScript strings, such as carriage 
       returns (\n), single quotes ('), and double quotes ("). 
    -> The purpose is to ensure that a string is safely embedded inside JavaScript code without 
       causing syntax errors.

    -> Consider an ERB partial (app/views/users/greeting.html.erb) that contains the following text:

    ```
    My name is <%= current_user.name %>, and I'm here to say "Welcome to our website!"
    ```

    -> If current_user.name = "John", then the rendered text would be:
    ```
    My name is John, and I'm here to say "Welcome to our website!"
    ```

    -> Now, suppose we want to use this text inside a JavaScript alert. If we insert it directly, 
       the quotes could break the JavaScript string. 
    -> To prevent this, we use escape_javascript:

    ```
    <script>
      var greeting = "<%= escape_javascript render('users/greeting') %>";
      alert(`Hello, ${greeting}`);
    </script>
    ```

    -> How It Works:
      -> escape_javascript render('users/greeting') ensures that any special characters are 
         escaped properly.
      -> Without escaping, the JavaScript code might break if the text contains quotes.
      -> The resulting JavaScript string is now safe to use in the script.

  
  ## 6.2 javascript_tag -----

    -> This helper generates a <script> tag around the provided JavaScript code.

    -> Passing JavaScript Code as an Argument
    ```
    <%= javascript_tag("alert('All is good')", type: "application/javascript") %>
    ```

    -> This generates html: 
    ```
    <script type="application/javascript">
    //<![CDATA[
    alert('All is good')
    //]]>
    </script>
    ```

    -> The <script> tag is generated automatically.
    -> The //<![CDATA[ ... //]]> wrapper is used to prevent issues with older XHTML-based browsers.
    -> The type="application/javascript" attribute ensures that the script is recognized as 
       JavaScript.
    

    -> Using a Block
    -> Instead of passing a string, we can also pass a block:

    ```
    <%= javascript_tag type: "application/javascript" do %>
      alert("Welcome to my app!")
    <% end %>
    ```

    -> This will output:
    ```
    <script type="application/javascript">
      alert("Welcome to my app!")
    </script>
    ````

    -> The block version is cleaner and allows for multi-line JavaScript code.
    -> Useful when adding inline JavaScript in views.




# 7 Alternative Tags */*/*/*/*

  -> The Rails tag helper and the token_list or class_names helper are useful for generating 
     dynamic HTML elements in a clean, programmatic way.

  
  ## 7.1 tag ----

    -> The tag helper allows us to create HTML elements dynamically in Rails views without writing
       raw HTML.

    ```
    tag.some_tag_name(optional content, options)
    ```

    -> some_tag_name → The HTML tag you want to generate (div, h1, section, etc.).
    -> optional content → The inner text or content inside the tag.
    -> options → A hash containing attributes for the tag (e.g., class, id, data-* attributes).


    -> Examples:
    ```
    tag.h1 "All titles fit to print"
    # => <h1>All titles fit to print</h1>
    
    tag.div "Hello, world!"
    # => <div>Hello, world!</div>
    ```

    -> Adding Attributes:
      -> we can pass attributes like class, id, etc.

      ```
      tag.section class: %w(kitties puppies)
      # => <section class="kitties puppies"></section>
      ```

    -> Adding data-* Attributes:
    ```
    tag.div data: { user_id: 123 }
    # => <div data-user-id="123"></div>
    ```

  
  ## 7.2 token_list ----

    -> This helper generates a space-separated string from multiple arguments. 
    -> It is commonly used for CSS class names.

    ```
    token_list(value1, value2, ...)

    or using its alias:

    class_names(value1, value2, ...)
    ```

    -> It filters out nil, false, and empty values ("").
    -> Hashes ({}) are converted based on truthy values.


    -> Example
    ```
    token_list("cats", "dogs")
    # => "cats dogs"

    token_list(nil, false, 123, "", "foo", { bar: true })
    # => "123 foo bar"

    mobile, alignment = true, "center"
    token_list("flex items-#{alignment}", "flex-col": mobile)
    # => "flex items-center flex-col"
    class_names("flex items-#{alignment}", "flex-col": mobile) # using the alias
    # => "flex items-center flex-col"
    ```



# 8 Capture Blocks */*/*/*/*

  -> Capture blocks help store dynamically generated content and reuse it in layouts or other
     parts of your views.
  

  ## 8.1 capture ----

    -> The capture method stores a block of content in a variable, which can be used later in a
       template, layout, or helper.

    -> Example: Storing Content in a Variable
    -> Before (Direct HTML in View)
    ```
    <p>Welcome! The date and time is <%= Time.current %></p>
    ```

    -> After (Using capture)
    ```
    <% @greeting = capture do %>
      <p>Welcome! The date and time is <%= Time.current %></p>
    <% end %>


    <html>
      <head><title>Welcome!</title></head>
      <body>
        <%= @greeting %>
      </body>
    </html>
    ```

    -> It stores the content inside a variable (@greeting), so you can reuse it anywhere.
    -> The block inside capture returns a string, allowing you to manipulate it or conditionally
       render it.

    

  ## 8.2 content_for ----

    -> The content_for method stores a block of content under a specific identifier, 
       so it can be used later.

    -> Instead of hardcoding the title inside the layout:
    ```
    <title>My App</title>
    ```

    -> we can define the title dynamically in our views and use it in the layout.
    
    -> Define Content in the View: 
    ```
    <% content_for(:html_title) { "Special Page Title" } %>
    ```

    -> Here, "Special Page Title" is stored in content_for(:html_title).

    -> Use it in the Layout: 
    ```
    <html>
      <head>
        <title><%= content_for?(:html_title) ? yield(:html_title) : "Default Title" %></title>
      </head>
    </html>
    ```

    

    -> we can define a helper to make things more reusable.

    ```
    module TitleHelper
      def html_title
        content_for(:html_title) || "Default Title"
      end
    end
    ```

    -> Use it in Layout
    ```
    <title><%= html_title %></title>
    ```

    -> Now, every page will: Use content_for(:html_title) if it's set.
    -> Otherwise, use "Default Title".




# 9 Performance */*/*/*/*

  -> Rails provides benchmarking and fragment caching to improve performance by identifying
     bottlenecks and reducing redundant computations.


  ## 9.1 benchmark ----

    -> Inside views, controllers, or helpers to measure the time taken for an expensive operation
       we can use benchmark.
    
    ```
    <% benchmark "Process data files" do %>
      <%= expensive_files_operation %>
    <% end %>
    ```

    -> Logs execution time in the Rails log like:
    ```
    Process data files (0.34523)
    ```
    -> Helps in identifying slow operations for optimization.

  

  ## 9.2 cache -----

    -> Inside views to cache parts of the page (fragments) instead of caching the entire page.
    -> Useful for menus, sidebars, repeated elements, or expensive database queries.


    ```
    <% cache do %>
      <%= render "application/footer" %>
    <% end %>
    ```

    -> The footer partial is stored in the cache.
    -> On the next request, Rails serves it without re-rendering, improving speed.


    -> Caching Each Article Individually

    ```
    <% @articles.each do |article| %>
      <% cache article do %>
        <%= render article %>
      <% end %>
    <% end %>
    ```

    -> Each article is cached separately.

    -> If an article does not change, Rails serves it from the cache instead of querying the 
       database.
    ```
    views/articles/index:bea67108094918eeba32cd4a6f786301/articles/1
    ```

    -> Each article has a unique cache key based on its ID and content.

    
















