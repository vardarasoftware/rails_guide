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





