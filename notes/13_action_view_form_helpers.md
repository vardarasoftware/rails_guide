# */*/*/*/* ---> Action View Form Helpers <--- */*/*/*/* 

# 1 Working with Basic Forms */*/*/*/*

  -> form_with is the main helper in Rails for creating forms. 
  -> It simplifies form generation while ensuring security features like CSRF protection are
     included.
  
  ```
  <%= form_with do |form| %>
    Form contents
  <% end %>
  ```

  -> This generates an HTML <form> element. 
  -> If no arguments are passed, it automatically sets: method to post, action to the current page
     URL
  

  -> For example, If we are on /home, then the generated HTML look like this:
  ```
  <form action="/home" accept-charset="UTF-8" method="post">
    <input type="hidden" name="authenticity_token" value="some_secure_token" autocomplete="off">
    Form contents
  </form>
  ```

  -> Hidden Authenticity Token
    > The hidden <input> field (authenticity_token) is automatically added.
    > It prevents Cross-Site Request Forgery (CSRF) attacks.
    > Rails verifies this token before processing form submissions to ensure the request is coming
      from a trusted source.
  
  
  -> Why Is CSRF Protection Needed?
    > Without CSRF protection, malicious websites could trick users into submitting unauthorized
      requests.
    > Rails automatically includes CSRF protection unless explicitly disabled.

  


  ## 1.1 A Generic Search Form -*-*-*-*

    -> A search form is a simple form used to take user input and submit it to a specific URL 
       using the GET method. 
    -> In Rails, we can create a search form using form_with.


    ```
    <%= form_with url: "/search", method: :get do |form| %>
      <%= form.label :query, "Search for:" %>
      <%= form.search_field :query %>
      <%= form.submit "Search" %>
    <% end %>
    ```

    -> Generated HTML output:
    ```
    <form action="/search" accept-charset="UTF-8" method="get">
      <label for="query">Search for:</label>
      <input type="search" name="query" id="query">
      <input type="submit" name="commit" value="Search" data-disable-with="Search">
    </form>
    ```

    -> The url: "/search" sets the action of the form.
    -> The 'method: :get' makes the form submit data using the GET method instead of the default
       POST.
    -> Generates a <label> tag for the input field.
    -> This improves accessibility and usability.
    -> Generates an <input type="search"> field for user input.
    -> The name="query" ensures the entered text is sent as a query parameter.
    -> Creates a <input type="submit"> button labeled "Search."
    -> The data-disable-with="Search" attribute helps prevent duplicate submissions.

  

  ## 1.2 Helpers for Generating Form Elements -*-*-*-*

    -> Rails provides form helper methods within form_with to generate different types of form
       inputs like text fields, checkboxes, and radio buttons. 
    -> These helpers make it easier to create forms while following Rails' naming conventions.


    ### 1.2.1 Checkboxes ---

      -> Checkboxes are used when we want users to select or deselect an option. 
      -> They are often used in groups to allow multiple selections.

      ```
      <%= form_with url: "/books" do |form| %>
        <%= form.check_box :biography %>
        <%= form.label :biography, "Biography" %>

        <%= form.check_box :romance %>
        <%= form.label :romance, "Romance" %>

        <%= form.check_box :mystery %>
        <%= form.label :mystery, "Mystery" %>
      <% end %>
      ```

      -> Generated HTMl:
      ```
      <input name="biography" type="hidden" value="0" autocomplete="off">
      <input type="checkbox" value="1" name="biography" id="biography">
      <label for="biography">Biography</label>

      <input name="romance" type="hidden" value="0" autocomplete="off">
      <input type="checkbox" value="1" name="romance" id="romance">
      <label for="romance">Romance</label>

      <input name="mystery" type="hidden" value="0" autocomplete="off">
      <input type="checkbox" value="1" name="mystery" id="mystery">
      <label for="mystery">Mystery</label>
      ```


      -> Hidden Input (type="hidden" value="0")
        > Rails automatically adds a hidden input before the checkbox.
        > If the checkbox is not checked, this hidden input ensures a "0" value is submitted.
        > If the checkbox is checked, the hidden input is ignored, and "1" is submitted.
      
      
      -> Checkbox Input (type="checkbox" value="1")
        > When the checkbox is checked, its value "1" is sent.
        > When the checkbox is unchecked, only the hidden input ("0") is sent.


      
      -> If the user only checks "Biography", the params hash will look like:

      ```
      {
        "biography" => "1",
        "romance" => "0",
        "mystery" => "0"
      }
      ```

      -> params[:biography] == "1" → Means "Biography" was selected.
      -> params[:romance] == "0" → Means "Romance" was not selected.
      -> params[:mystery] == "0" → Means "Mystery" was not selected.


    

    ### 1.2.2 Radio Buttons ---

      -> Radio buttons allow users to select only one option from a set of predefined choices.
      -> Unlike checkboxes, radio buttons ensure that only one value is sent when the form is
         submitted.

      ```
      <%= form.radio_button :flavor, "chocolate_chip" %>
      <%= form.label :flavor_chocolate_chip, "Chocolate Chip" %>

      <%= form.radio_button :flavor, "vanilla" %>
      <%= form.label :flavor_vanilla, "Vanilla" %>

      <%= form.radio_button :flavor, "hazelnut" %>
      <%= form.label :flavor_hazelnut, "Hazelnut" %>
      ```

      -> Generated HTML:

      ```
      <input type="radio" value="chocolate_chip" name="flavor" id="flavor_chocolate_chip">
      <label for="flavor_chocolate_chip">Chocolate Chip</label>

      <input type="radio" value="vanilla" name="flavor" id="flavor_vanilla">
      <label for="flavor_vanilla">Vanilla</label>

      <input type="radio" value="hazelnut" name="flavor" id="flavor_hazelnut">
      <label for="flavor_hazelnut">Hazelnut</label>
      ```

      -> The name="flavor" attribute
        -> All radio buttons share the same name (flavor), meaning only one can be selected at a 
           time.
        -> If the user selects "Vanilla", the submitted value will be:
      ```
      params[:flavor]  # => "vanilla"
      ```

      
      -> The value="..." attribute
        -> Each radio button has a unique value (chocolate_chip, vanilla, hazelnut).
        -> This value is what gets sent to the controller when the form is submitted.


    -> The label tag
      -> The label makes the radio button clickable.
      -> Clicking on the label selects the corresponding radio button.



  ## 1.3 Other Helpers of Interest -*-*-*-*

    -> Rails provides various helpers to create different types of form inputs. 
    -> These helpers generate HTML input fields that allow users to input dates, times, passwords,
       emails, numbers, colors, etc.
    
    -> Date and Time related helpers: 
    ```
    <%= form.date_field :born_on %>
    <%= form.time_field :started_at %>
    <%= form.datetime_local_field :graduation_day %>
    <%= form.month_field :birthday_month %>
    <%= form.week_field :birthday_week %>
    ```

    -> Generated HTML:
    ```
    <input type="date" name="born_on" id="born_on">
    <input type="time" name="started_at" id="started_at">
    <input type="datetime-local" name="graduation_day" id="graduation_day">
    <input type="month" name="birthday_month" id="birthday_month">
    <input type="week" name="birthday_week" id="birthday_week">


    -> date_field → For selecting a full date (YYYY-MM-DD).
    -> time_field → For selecting only time (HH:MM).
    -> datetime_local_field → For selecting both date & time.
    -> month_field → For selecting a specific month.
    -> week_field → For selecting a week number within a year.



    --> Helpers with special formating:

      -> These helpers are used for specific input types like passwords, emails, phone numbers, and URLs.
      ```
      <%= form.password_field :password %>
      <%= form.email_field :address %>
      <%= form.telephone_field :phone %>
      <%= form.url_field :homepage %>


      -> Generated HTML
      ```
      <input type="password" name="password" id="password">
      <input type="email" name="address" id="address">
      <input type="tel" name="phone" id="phone">
      <input type="url" name="homepage" id="homepage">


      -> Usage: 
        > password_field → Hides the entered text (for passwords).
        > email_field → Ensures a valid email format (@ required).
        > telephone_field → Ensures a valid phone number format.
        > url_field → Ensures a valid URL format.

    
    --> other common helpers:

      -> These helpers create various input types such as text areas, hidden fields, numeric 
         inputs, ranges, searches, and color pickers.

      ```
      <%= form.text_area :message, size: "70x5" %>
      <%= form.hidden_field :parent_id, value: "foo" %>
      <%= form.number_field :price, in: 1.0..20.0, step: 0.5 %>
      <%= form.range_field :discount, in: 1..100 %>
      <%= form.search_field :name %>
      <%= form.color_field :favorite_color %>
      ```

      -> Generated HTML: 
      ```
      <textarea name="message" id="message" cols="70" rows="5"></textarea>
      <input type="hidden" name="parent_id" id="parent_id" value="foo">
      <input type="number" name="price" id="price" step="0.5" min="1.0" max="20.0">
      <input type="range" name="discount" id="discount" min="1" max="100">
      <input type="search" name="name" id="name">
      <input type="color" name="favorite_color" id="favorite_color" value="#000000">
      ```


      -> text_area → For multi-line text input.
      -> hidden_field → Stores data that users cannot see.
      -> number_field → Restricts input to numeric values.
      -> range_field → Creates a slider for selecting a range.
      -> search_field → Optimized for search boxes.
      -> color_field → Opens a color picker.




# 2 Creating Forms with Model Objects */*/*/*/*

  ## 2.1 Binding a Form to an Object -*-*-*-*

    -> When we pass model: @book, Rails:
      > Automatically sets the form’s action.
      > Scopes input fields to the model, so submitted data is properly structured.
      > Prefills the form fields if the model has existing data.

    ```
    def new
      @book = Book.new
    end

    def create
      @book = Book.new(book_params)
      if @book.save
        redirect_to @book, notice: "Book created successfully!"
      else
        render :new
      end
    end

    private

    def book_params
      params.require(:book).permit(:title, :author)
    end
    ```

    -> This ensures that only title and author parameters are permitted.

    -> View (new.html.erb)

    ```
    <%= form_with model: @book do |form| %>
      <div>
        <%= form.label :title %>
        <%= form.text_field :title %>
      </div>
      <div>
        <%= form.label :author %>
        <%= form.text_field :author %>
      </div>
      <%= form.submit %>
    <% end %>
    ```
    -> This form will automatically:
      > Use the correct path (/books for new, /books/:id for edit).
      > Scope parameters correctly (book[title], book[author]).


    -> When the form is rendered, it generates HTML like:
    ```
    <form action="/books" accept-charset="UTF-8" method="post">
      <input type="hidden" name="authenticity_token" value="...">
      <div>
        <label for="book_title">Title</label>
        <input type="text" name="book[title]" id="book_title">
      </div>
      <div>
        <label for="book_author">Author</label>
        <input type="text" name="book[author]" id="book_author">
      </div>
      <input type="submit" value="Create Book">
    </form>

    ```

    -> Form action is set automatically
      > When creating a new book, it posts data to /books (calling create).
      > When editing a book (@book has an ID), it posts to /books/:id (calling update).

    -> Field names are scoped
      > Input names are like book[title] instead of just title, so params[:book] will be a hash {
        title: "...", author: "..." }.
    
    -> Form fields are prefilled
      > If @book already has values (like when editing), they appear in the form fields.

    



    ### 2.1.1 Composite Primary Key Forms ----

      -> In Rails, models usually have a single primary key (id). 
      -> However, sometimes a model might use a composite primary key—a combination of two or more
         columns that uniquely identify a record.
      
      -> Consider a Book model where each book is uniquely identified by both its author_id and id:
      ```
      @book = Book.find([2, 25])
      # This finds a book where author_id = 2 and id = 25
      ```

      -> Here: author_id = 2, id = 25
      -> Together, they form a composite primary key.


      -> When using form_with model: @book, Rails generates the form based on the primary key.

      ```
      <%= form_with model: @book do |form| %>
        <%= form.text_field :title %>
        <%= form.submit %>
      <% end %>
      ```

      -> Generated HTML:
      ```
      <form action="/books/2_25" method="post" accept-charset="UTF-8">
        <input name="authenticity_token" type="hidden" value="XYZ..." />
        <input type="text" name="book[title]" id="book_title" value="Some book" />
        <input type="submit" name="commit" value="Update Book">
      </form>
      ```

      
      -> The URL contains both author_id and id as 2_25
        > Rails automatically combines the composite keys using an underscore.
        > The controller will use this to locate the correct record.
      
      -> Field names remain the same (book[title])
        > The form is still bound to the @book object.


    

    ### 2.1.2 The fields_for Helper ---

      -> The fields_for helper in Rails is used inside a form_with block to handle nested
         attributes.
      -> This is useful when a model has an associated model and you want to include both in the
         same form.

      
      -> Let's say we have two models:
        > Person model (Main model)
        > ContactDetail model (Associated model, belongs to Person)

      
      -> Person Model
      ```
      class Person < ApplicationRecord
        has_one :contact_detail
        accepts_nested_attributes_for :contact_detail
      end
      ```

      -> ContactDetail Model
      ```
      class ContactDetail < ApplicationRecord
        belongs_to :person
      end
      ```



      ```
      <%= form_with model: @person do |person_form| %>
        <%= person_form.text_field :name %>

        <%= fields_for :contact_detail, @person.contact_detail do |contact_detail_form| %>
          <%= contact_detail_form.text_field :phone_number %>
        <% end %>

      <% end %>
      ```


      -> form_with creates a form for @person (the main model).
      -> fields_for :contact_detail, @person.contact_detail generates fields for the associated
         ContactDetail model.
      -> It does not create a separate <form> tag. Instead, it embeds the nested fields inside the
         main form.
      


      -> Generated HTML Output
      ```
      <form action="/people" accept-charset="UTF-8" method="post">
        <input type="hidden" name="authenticity_token" value="..." autocomplete="off" />

        <!-- Person name field -->
        <input type="text" name="person[name]" id="person_name" />

        <!-- ContactDetail phone number field -->
        <input type="text" name="contact_detail[phone_number]" id="contact_detail_phone_number" />
      </form>
      ````

      -> How does this work?
        > The person[name] field belongs to Person.
        > The contact_detail[phone_number] field belongs to ContactDetail.




  ## 2.2 Relying on Record Identification -*-*-*-*

    -> Rails provides a smart way to handle forms for models without explicitly specifying the 
       URL or HTTP method. 
    -> This feature is called Record Identification. 
    -> It allows Rails to automatically determine:
      > The form action URL
      > The HTTP method
      > The model name and field names

    -> When creating a new Article, both of the following forms generate the same HTML.

    ```
    # longer way:
    form_with(model: @article, url: articles_path)
    
    # short-hand:
    form_with(model: @article)
    ```

    -> Rails automatically detects that @article is a new record.
    -> It sets the form's action to /articles.
    -> Uses POST as the HTTP method.



    --> When editing an existing Article, both approaches also produce the same result.

    ```
    # longer way:
    form_with(model: @article, url: article_path(@article), method: "patch")
    
    # short-hand:
    form_with(model: @article)
    ```

    -> Rails detects that @article.persisted? is true.
    -> It automatically sets the form's action to /articles/:id.
    -> Uses PATCH as the HTTP method.



    -> For a singleton resource, resources changes to resource in routes.rb:
    ```
    resource :article
    ```

    -> What’s different here?
      > The URL will not include an :id.
      > To ensure form_with works, we add resolve in routes.rb


    ```
    resolve("Article") { [:article] }
    ```
    -> This tells Rails how to generate the correct path (/article) when using 
       form_with(model: @article).



  ## 2.3 Working with Namespaces -*-*-*-*

    -> In Rails, namespaces are used to group controllers under a module. 
    -> This is commonly done for admin panels, APIs, or organized structures. 
    -> When we have namespaced routes, form_with provides a shorthand to ensure the form submits
       to the correct controller.

    -> If you just write:
    ```
    <%= form_with model: [:admin, @article] %>
    ```

    -> Rails understands that @article belongs to the Admin namespace.
    -> It automatically generates the correct URL: /admin/articles for new records, 
       /admin/articles/:id for existing records
    -> It submits the form to Admin::ArticlesController.


    -> Using form_with:

    ```
    <%= form_with model: [:admin, :management, @article] %>
    ```

    -> Rails automatically generates the correct route:
      > New article: /admin/management/articles
      > Editing article: /admin/management/articles/:id
      > Controller: Admin::Management::ArticlesController

  

  ## 2.4 Forms with PATCH, PUT, or DELETE Methods -*-*-*-*

    -> In Rails, forms need to support HTTP methods like PATCH, PUT, and DELETE, but HTML forms
       natively only support GET and POST. 
    -> To work around this limitation, Rails emulates these additional methods using a hidden
       input field named "_method".

    
    -> When you create a form with method: :patch, Rails automatically converts it into a POST
       request but adds:

    ```
    <input type="hidden" name="_method" value="patch">
    ```

    -> This tells Rails that the request should be interpreted as PATCH instead of POST.

    -> Example Form: PATCH Request

    ```
    <%= form_with(url: search_path, method: "patch") do |form| %>
      <%= form.text_field :query %>
      <%= form.submit "Update" %>
    <% end %>
    ```

    -> This generates:

    ```
    <form action="/search" method="post">
      <input type="hidden" name="_method" value="patch">
      <input type="hidden" name="authenticity_token" value="...">
      <input type="text" name="query">
      <input type="submit" value="Update">
    </form>
    ```

    -> Even though the form's method is POST, Rails interprets it as PATCH because of the hidden
       "_method" field.
    


    -> Instead of defining the method in form_with, we can specify it at the button level using
       formmethod.

    ```
    <%= form_with url: "/posts/1", method: :patch do |form| %>
      <%= form.button "Delete", formmethod: :delete, data: { confirm: "Are you sure?" } %>
      <%= form.button "Update" %>
    <% end %>
    ```


    -> Generated HTML: 
    ```
    <form action="/posts/1" method="post">
      <input type="hidden" name="_method" value="patch">
      <input type="hidden" name="authenticity_token" value="...">

      <button type="submit" formmethod="post" name="_method" value="delete" data-confirm="Are you sure?">Delete</button>
      <button type="submit">Update</button>
    </form>
    ```

    -> "Update" button submits as PATCH
    -> "Delete" button submits as DELETE (overridden using formmethod="post" and _method="delete")



    --> When to Use This?
      > Use 'PATCH' for updating existing records.
      > Use 'PUT' if you replace an entire record instead of updating specific fields.
      > Use 'DELETE' for removing records




# 3 Making Select Boxes with Ease */*/*/*/*

  -> Select boxes (drop-down lists) allow users to pick one value from a list of options. 
  -> Instead of writing long HTML manually, Rails provides helper methods to generate select boxes
     efficiently.

  
  -> we can create a simple select box with predefined choices.
  ```
  <%= form.select :city, ["Berlin", "Chicago", "Madrid"] %>
  ```

  -> Generated HTML: 
  ```
  <select name="city" id="city">
    <option value="Berlin">Berlin</option>
    <option value="Chicago">Chicago</option>
    <option value="Madrid">Madrid</option>
  </select>
  ```

  -> The user sees: Berlin, Chicago, Madrid
  -> The selected value is stored in params[:city] as the same name (e.g., "Berlin").


  -> Instead of using the same value for both display and storage, we can store a different value
     than what the user sees.
  
  ```
  <%= form.select :city, [["Berlin", "BE"], ["Chicago", "CHI"], ["Madrid", "MD"]] %>
  ```

  -> Generated HTML:
  
  ```
  <select name="city" id="city">
    <option value="BE">Berlin</option>
    <option value="CHI">Chicago</option>
    <option value="MD">Madrid</option>
  </select>
  ```

  -> The user sees: Berlin, Chicago, Madrid
  -> The value stored in params[:city] is BE, CHI, or MD instead of the full name.


  -> we can specify a default selected value using the selected: option.

  ```
  <%= form.select :city, [["Berlin", "BE"], ["Chicago", "CHI"], ["Madrid", "MD"]], selected: "CHI" %>
  ```


  -> Geneerated HTML:
  
  ```
  <select name="city" id="city">
    <option value="BE">Berlin</option>
    <option value="CHI" selected="selected">Chicago</option>
    <option value="MD">Madrid</option>
  </select>
  ```

  -> The default selection is Chicago (CHI is pre-selected).
  -> Users can still change it.


  ##  3.1 Option Groups for Select Boxes -*-*-*-*

    -> Sometimes, it helps to group related options together to improve user experience. 
    -> This is done using option groups (<optgroup>) inside the <select> tag.

    ```
    <%= form.select :city,
      {
        "Europe" => [ ["Berlin", "BE"], ["Madrid", "MD"] ],
        "North America" => [ ["Chicago", "CHI"] ],
      },
      selected: "CHI" %>
    ```


    -> Generated HTML: 
    ```
    <select name="city" id="city">
      <optgroup label="Europe">
        <option value="BE">Berlin</option>
        <option value="MD">Madrid</option>
      </optgroup>
      <optgroup label="North America">
        <option value="CHI" selected="selected">Chicago</option>
      </optgroup>
    </select>
    ```

    -> The options are grouped under "Europe" and "North America" using <optgroup>.
    -> The user sees cities grouped by continent.
    -> The value stored in params[:city] is "CHI", since it's pre-selected.

  
  ## 3.2 Binding Select Boxes to Model Attributes -*-*-*-*

    -> Select boxes can be directly bound to a model so that when the form is submitted, 
       the selected value is saved in the database.
    
    ```
    @person = Person.new(city: "MD")
    ```

    -> Here, @person.city is "MD" (Madrid).

    -> Form with Select Box Bound to the city Attribute

    ```
    <%= form_with model: @person do |form| %>
      <%= form.select :city, [["Berlin", "BE"], ["Chicago", "CHI"], ["Madrid", "MD"]] %>
    <% end %>
    ```

    
    -> Generated HTML:
    ```
    <select name="person[city]" id="person_city">
      <option value="BE">Berlin</option>
      <option value="CHI">Chicago</option>
      <option value="MD" selected="selected">Madrid</option>
    </select>


    -> Since @person.city = "MD", Madrid is automatically selected.
    -> No need to manually set selected: "MD", because Rails detects it from the model.
    -> The submitted value is stored in params[:person][:city].

    





# 4 Using Date and Time Form Helpers */*/*/*/*

  -> Rails provides special form helpers for handling date and time fields. 
  -> Instead of using a single text input, these helpers generate dropdown select boxes for each
     part (year, month, day, hour, minute).

  -> Creates three select boxes (Year, Month, Day) for choosing a date.

  ```
  <%= form_with model: @person do |form| %>
    <%= form.date_select :birth_date %>
  <% end %>
  ```

  -> What happens here: 
    -> If @person.birth_date = Date.new(1995, 12, 21), it will pre-select:
      > Year: 1995
      > Month: December
      > Day: 21

  
  -> Gnerated HTML:

  ```
  <select name="person[birth_date(1i)]" id="person_birth_date_1i">
    <option value="1990">1990</option>
    <option value="1991">1991</option>
    <option value="1992">1992</option>
    <option value="1993">1993</option>
    <option value="1994">1994</option>
    <option value="1995" selected="selected">1995</option>
    <option value="1996">1996</option>
    <option value="1997">1997</option>
    <option value="1998">1998</option>
    <option value="1999">1999</option>
    <option value="2000">2000</option>
  </select>
  <select name="person[birth_date(2i)]" id="person_birth_date_2i">
    <option value="1">January</option>
    <option value="2">February</option>
    <option value="3">March</option>
    <option value="4">April</option>
    <option value="5">May</option>
    <option value="6">June</option>
    <option value="7">July</option>
    <option value="8">August</option>
    <option value="9">September</option>
    <option value="10">October</option>
    <option value="11">November</option>
    <option value="12" selected="selected">December</option>
  </select>
  <select name="person[birth_date(3i)]" id="person_birth_date_3i">
    <option value="1">1</option>
    ...
    <option value="21" selected="selected">21</option>
    ...
    <option value="31">31</option>
  </select>
  ```

  -> When submitted, Rails receives:

    ```
    params[:person][:birth_date(1i)] # "1995" (Year)
    params[:person][:birth_date(2i)] # "12" (Month)
    params[:person][:birth_date(3i)] # "21" (Day)
    ```

  -> Rails automatically combines these values into a full date 1995-12-21.

  

  ## 4.1 Select Boxes for Time or Date Components -*-*-*-*

    -> Instead of generating a full date/time input, Rails provides bare methods to create 
       separate dropdowns for year, month, day, hour, minute, and second.
    

    ```
    <%= select_year 2024, prefix: "party" %>
    ```

    -> Generated HTML:
    ```
    <select id="party_year" name="party[year]">
      <option value="2019">2019</option>
      <option value="2020">2020</option>
      <option value="2021">2021</option>
      <option value="2024" selected="selected">2024</option>
      <option value="2029">2029</option>
    </select>
    ```

    -> 2024 is the default selected year.
    -> prefix: "party" sets the name attribute to "party[year]".

  

  ## 4.2 Selecting Time Zone -*-*-*-*

    -> When asking users to select a time zone, Rails provides a predefined list of time zones
       using ActiveSupport::TimeZone.

    ```
    <%= form.time_zone_select :time_zone %>
    ```

    -> Generated HTML:
    ```
    <select name="time_zone" id="time_zone">
      <option value="International Date Line West">(GMT-12:00) International Date Line West</option>
      <option value="American Samoa">(GMT-11:00) American Samoa</option>
      <option value="Midway Island">(GMT-11:00) Midway Island</option>
      <option value="Hawaii">(GMT-10:00) Hawaii</option>
      <option value="Alaska">(GMT-09:00) Alaska</option>
      ...
      <option value="Samoa">(GMT+13:00) Samoa</option>
      <option value="Tokelau Is.">(GMT+13:00) Tokelau Is.</option>
    </select>
    ```

    -> Generates a select box with all time zones and their respective GMT offsets.
    -> The selected value will be stored in params[:user][:time_zone].

    



# 5 Collection Related Helpers */*/*/*/*

  -> Rails provides collection-related helpers to simplify the process of generating form inputs 
     from a collection of objects. 
  -> These helpers are especially useful when you have a model association (like belongs_to) and
     need to generate a dropdown, radio buttons, or checkboxes.
  
  -> If we want a form where users can select a city for a person, we can manually generate the
     options:

  ```
  <%= form_with model: @person do |form| %>
    <%= form.select :city_id, City.order(:name).map { |city| [city.name, city.id] } %>
  <% end %>
  ```

  -> It retrieves cities ordered by name.
  -> It maps each city into an array where:
    > The first element (city.name) is the display text.
    > The second element (city.id) is the value submitted when the form is saved.
  -> The result is used as the options for a select dropdown.


  -> This generates the HTML:
  ```
  <select name="person[city_id]" id="person_city_id">
    <option value="1">Berlin</option>
    <option value="3">Chicago</option>
    <option value="2">Madrid</option>
  </select>
  ```

  

  ## 5.1 The collection_select Helper -*-*-*-*

    -> The collection_select helper generates a dropdown (select box) from a collection of objects.

    ```
    <%= form.collection_select :city_id, City.order(:name), :id, :name %>
    ```

    -> :city_id → The attribute that stores the selected value (person.city_id).
    -> City.order(:name) → The collection of cities, ordered alphabetically.
    -> :id → The method used for the option value (city ID).
    -> :name → The method used for the option text (city name).


    -> Generated HTML Output
    ```
    <select name="person[city_id]" id="person_city_id">
      <option value="1">Berlin</option>
      <option value="3">Chicago</option>
      <option value="2">Madrid</option>
    </select>
    ```

    -> Key Difference Between select and collection_select: 
      
      > When using select, you provide choices manually as [text, value], e.g., ["Berlin", 1].
      > When using collection_select, Rails extracts values directly from the objects using the 
        specified methods (:id and :name).
    

  

  ## 5.2 collection_radio_buttons Helper *-*-*-*-*

    -> The collection_radio_buttons helper generates a group of radio buttons from a collection.

    ```
    <%= form.collection_radio_buttons :city_id, City.order(:name), :id, :name %>
    ```


    -> Generated HTML Output
    ```
    <input type="radio" value="1" name="person[city_id]" id="person_city_id_1">
    <label for="person_city_id_1">Berlin</label>

    <input type="radio" value="3" name="person[city_id]" id="person_city_id_3">
    <label for="person_city_id_3">Chicago</label>

    <input type="radio" value="2" name="person[city_id]" id="person_city_id_2">
    <label for="person_city_id_2">Madrid</label>
    ```


    -> Each <input type="radio"> has a unique value (city ID).
    -> The name="person[city_id]" ensures that only one city can be selected.
    -> The <label> is linked to each radio button using the for attribute.


  
  ## 5.3 collection_checkboxes Helper *-*-*-*-*-*

    -> The collection_checkboxes helper generates a set of checkboxes for multiple selections.
    -> This is useful for has_and_belongs_to_many (HABTM) or has_many :through associations.

    ```
    <%= form.collection_checkboxes :interest_ids, Interest.order(:name), :id, :name %>
    ```


    -> Generated HTML Output
    ```
    <input type="checkbox" name="person[interest_id][]" value="3" id="person_interest_id_3">
    <label for="person_interest_id_3">Engineering</label>

    <input type="checkbox" name="person[interest_id][]" value="4" id="person_interest_id_4">
    <label for="person_interest_id_4">Math</label>

    <input type="checkbox" name="person[interest_id][]" value="1" id="person_interest_id_1">
    <label for="person_interest_id_1">Science</label>

    <input type="checkbox" name="person[interest_id][]" value="2" id="person_interest_id_2">
    <label for="person_interest_id_2">Technology</label>
    ```


    -> Each checkbox represents an interest with its ID as the value.
    -> The name="person[interest_id][]" (with []) allows multiple selections.
    -> Labels are linked to their respective checkboxes.




# 6 Uploading Files */*/*/*/*/*

  -> File uploads are a common requirement in web applications, such as uploading profile
     pictures, CSV files, or documents. 
  -> Rails makes this easy with the file_field helper.

  -> Rails provides the file_field helper inside form_with to create a file upload input field.

  ```
  <%= form_with model: @person do |form| %>
    <%= form.file_field :csv_file %>
  <% end %>
  ```

  -> form.file_field :csv_file → Creates a file input field for the csv_file attribute.
  -> form_with model: @person → The file will be part of the @person object.
  -> The uploaded file will be available in params[:person][:csv_file].

  -> multipart/form-data Requirement:
    > For file uploads to work, the form must have enctype="multipart/form-data".
    > This ensures that files are properly encoded and sent to the server.

  -> Using file_field_tag Without a Model:
    > If we're not working with a model, we can use file_field_tag inside form_with and manually
      set multipart: true:
    ```
    <%= form_with url: "/uploads", multipart: true do |form| %>
      <%= file_field_tag :csv_file %>
    <% end %>
    ```


  -> Generated HTML:
  ```
  <form enctype="multipart/form-data" action="/people" accept-charset="UTF-8" method="post">
    <input type="file" name="person[csv_file]" id="person_csv_file">
  </form>
  ```

  -> <form enctype="multipart/form-data"> → Required for file uploads.
  -> <input type="file" name="person[csv_file]"> → File input field.


  ## 6.1 CSV File Upload Example -*-*-*-*-*

    -> When we use file_field in Rails, the uploaded file is an instance of 
       ActionDispatch::Http::UploadedFile, which provides methods to read and process the file.

    -> The provided example shows how to parse a CSV file and store its data into a model.
    ```
    <%= form_with url: "/upload_csv", multipart: true do |form| %>
      <%= form.file_field :csv_file %>
      <%= form.submit "Upload CSV" %>
    <% end %>
    ```


    -> Handle CSV Upload in Controller 

    ```
      require "csv"

      def upload
        uploaded_file = params[:csv_file]
        if uploaded_file.present?
          csv_data = CSV.parse(uploaded_file.read, headers: true)
          csv_data.each do |row|
            # Process each row of the CSV file
            # SomeInvoiceModel.create(amount: row['Amount'], status: row['Status'])
            Rails.logger.info row.inspect
            #<CSV::Row "id":"po_1KE3FRDSYPMwkcNz9SFKuaYd" "Amount":"96.22" "Created (UTC)":"2022-01-04 02:59" "Arrival Date (UTC)":"2022-01-05 00:00" "Status":"paid">
          end
        end
        # ...
      end
    ```

    -> This retrieves the uploaded file from the form.
    -> Ensures a file was uploaded before proceeding.
    -> uploaded_file.read → Reads file contents.
    -> CSV.parse(..., headers: true) → Parses the file with headers.
    -> Reads CSV rows and saves them as records in the database.





# 7 Customizing Form Builders */*/*/*/*

  -> Form builders in Rails help generate form elements tied to a model. 
  -> we can customize them to add reusable form elements across your application.

  ->  Why Customize Form Builders?
    > Reduces Repetition: Instead of writing the same label and text field multiple times, 
      we can create a helper.
    > Improves Readability: Code becomes cleaner and easier to maintain.
    > Allows Custom Styling: we can enforce specific form structures or styles globally.

  
  -> Imagine we always want to display a text field with a label. 
  -> Instead of repeating this:
    ```
    <%= form.label :first_name %>
    <%= form.text_field :first_name %>
    ```
  
  -> we can create a helper method in application_helper.rb:
    ```
    module ApplicationHelper
      def text_field_with_label(form, attribute)
        form.label(attribute) + form.text_field(attribute)
      end
    end
    ```

  -> Now, in our form:
    ```
    <%= form_with model: @person do |form| %>
      <%= text_field_with_label form, :first_name %>
    <% end %>
    ```

  -> This simplifies our form structure while keeping the same functionality.


  -> Instead of using a helper, we can subclass ActionView::Helpers::FormBuilder to override form
     methods.

    ```
    class LabellingFormBuilder < ActionView::Helpers::FormBuilder
      def text_field(attribute, options = {})
        label(attribute) + super
      end
    end
    ```

  -> super calls the original text_field method.
  -> label(attribute) + super ensures every text field automatically includes a label.


  -> Use Custom Builder in Forms
    ```
    <%= form_with model: @person, builder: LabellingFormBuilder do |form| %>
      <%= form.text_field :first_name %>
    <% end %>
    ```
  -> No need to manually add labels!
  

  -> Instead of specifying the builder every time, create a helper that applies it automatically.

  -> Define labeled_form_with in ApplicationHelper
    ```
    module ApplicationHelper
      def labeled_form_with(**options, &block)
        options[:builder] = LabellingFormBuilder
        form_with(**options, &block)
      end
    end
    ```

  -> Use It in our Views
    ```
    <%= labeled_form_with model: @person do |form| %>
      <%= form.text_field :first_name %>
    <% end %>
    ```

  
  -> Even shorter syntax with the same automatic label feature!


  -> When rendering a form builder inside a partial:

    ```
    <%= render partial: f %>
    ```

  -> If f is a default form builder (ActionView::Helpers::FormBuilder), it will render form 
     partial.
  -> If f is LabellingFormBuilder, it will render the labelling_form partial instead.







# 8 Form Input Naming Conventions and params Hash */*/*/*/*

  -> When a user submits a form in Rails, the values they entered are sent as a params hash to
     the controller. 
  -> This allows us to access user input and process it accordingly.
  -> HTML forms don’t inherently have structured data. 
  -> They only send name-value pairs.
  -> Rails interprets these names into structured hashes and arrays.


  -> Forms send data as name-value pairs, but Rails structures them using naming conventions.
  -> If you use form_with model: @object, inputs are nested inside params[:object].
  -> Check boxes automatically become arrays inside params.
  -> When handling multiple associated records, fields_for creates an array of hashes.


  ## 8.1 Basic Structure -*-*-*-*

    -> A hash structure in Rails mimics object attributes.
    -> Each input field uses the name attribute to specify where the data will go in the params
       hash.
    
    ```
    <input id="person_name" name="person[name]" type="text" value="Henry"/>
    ```

    -> Resulting params Hash
      ```
      { "person" => { "name" => "Henry" } }
      ```
    
    -> How to Access It in the Controller
      ```
      params[:person][:name]  # => "Henry"
      ```
    
    -> Since the input name is person[name], Rails automatically nests it inside params[:person].



    -> we can nest hashes to group related fields together
    
    ```
    <input id="person_address_city" name="person[address][city]" type="text" value="New York"/>
    ```

    -> Resulting params Hash
    ```
    { "person" => { "address" => { "city" => "New York" } } }
    ```


    -> How to Access It in the Controller
    ```
    params[:person][:address][:city]  # => "New York"
    ```

    -> This helps structure complex forms with multiple related attributes.



    -> If multiple fields share the same name with square brackets ([]) at the end, Rails collects them into an array.

    -> Example: Multiple Phone Numbers

    ```
    <input name="person[phone_number][]" type="text" value="555-0123"/>
    <input name="person[phone_number][]" type="text" value="555-0124"/>
    <input name="person[phone_number][]" type="text" value="555-0125"/>
    ```

    -> Resulting params Hash
    ```
    {
      "person" => {
        "phone_number" => ["555-0123", "555-0124", "555-0125"]
      }
    }
    ```


    -> How to Access It in the Controller
    ```
    params[:person][:phone_number]  # => ["555-0123", "555-0124", "555-0125"]
    ```

    -> Using [] tells Rails to treat it as an array, so multiple values are stored together.

  

  ## 8.2 Combining Arrays and Hashes -*-*-*-*

    -> A hash can have keys where the values are arrays.
    -> For example, in a form submission, the params[:person] hash might contain a key
       :phone_numbers whose value is an array:

    ```
    params[:person] = {
      name: "John Doe",
      phone_numbers: ["123-456-7890", "987-654-3210"]
    }
    ```

    -> So, params[:person][:phone_numbers] is an array of phone numbers.


    -> we can also store an array of hashes, where each element is a hash containing multiple
       key-value pairs.
    ```
    <input name="person[addresses][][line1]" type="text"/>
    <input name="person[addresses][][line2]" type="text"/>
    <input name="person[addresses][][city]" type="text"/>
    <input name="person[addresses][][line1]" type="text"/>
    <input name="person[addresses][][line2]" type="text"/>
    <input name="person[addresses][][city]" type="text"/>
    ```

    -> Here, addresses is an array, and each entry in it is a hash with keys line1, line2, and
       city.
    -> When this form is submitted, Rails will structure the parameters like this:
      ```
      params[:person] = {
        addresses: [
          { line1: "1000 Fifth Avenue", line2: "", city: "New York" },
          { line1: "Calle de Ruiz de Alarcón", line2: "", city: "Madrid" }
        ]
      }
      ```

    -> Here, params[:person][:addresses] is an array of hashes, where each hash represents a 
       separate address.


  

  ## 8.3 Hashes with an Index -*-*-*-*

    -> This concept explains how to use fields_for with the :index option in Rails forms. 
    -> It helps organize nested form fields efficiently, especially when working with associated
       records like addresses for a person.

    ```
    <%= form_with model: @person do |person_form| %>
      <%= person_form.text_field :name %>
      <% @person.addresses.each do |address| %>
        <%= person_form.fields_for address, index: address.id do |address_form| %>
          <%= address_form.text_field :city %>
        <% end %>
      <% end %>
    <% end %>
    ```

    -> form_with model: @person
      > Creates a form for the @person object.
      > The form will submit data to update @person.
    
    -> Looping through addresses (@person.addresses.each do |address|)
      > This iterates over each address the person has.
    
    -> Using fields_for address, index: address.id
      > fields_for creates fields for the address object inside the person form.
      > The index: address.id ensures that each address is uniquely identified.
    
    -> Generating the city input field (address_form.text_field :city)
      > Creates a text field for the city attribute of each address.
    

    -> The Generated HTML Output:
    ```
    <form accept-charset="UTF-8" action="/people/1" method="post">
      <input name="_method" type="hidden" value="patch" />
      <input id="person_name" name="person[name]" type="text" />
      <input id="person_address_23_city" name="person[address][23][city]" type="text" />
      <input id="person_address_45_city" name="person[address][45][city]" type="text" />
    </form>
    ```

    -> Each address has a unique input name → person[address][23][city], person[address][45][city]
    -> The index (address.id) appears in the input name, helping identify which address each 
       field belongs to.
    

    -> When the form is submitted, Rails will generate the following params hash:

    ```
    {
      "person" => {
        "name" => "Bob",
        "address" => {
          "23" => { "city" => "Paris" },
          "45" => { "city" => "London" }
        }
      }
    }
    ```

    -> The "person" key contains the person’s details.
    -> The "address" key contains a hash of addresses.
    -> Each address is identified by its ID (23, 45).
    -> Each address hash contains the city field.



# 9 Building Complex Forms */*/*/*/*

  ## 9.1 Configuring the Model for Nested Attributes -*-*-*-*

    -> When our application requires editing multiple associated records within the same form,
       Rails provides a way to handle this efficiently using nested attributes.
    

    -> Suppose we have a Person model.
    -> Each person has multiple addresses (home, work, etc.).
    -> We want to add, update, or remove addresses while editing a person in a single form.

    -> The Solution: accepts_nested_attributes_for
    -> To enable this, we configure the Person model to accept nested attributes for its
       addresses.

    ```
    class Person < ApplicationRecord
      has_many :addresses, inverse_of: :person
      accepts_nested_attributes_for :addresses
    end

    class Address < ApplicationRecord
      belongs_to :person
    end
    ```


    ```
    accepts_nested_attributes_for :addresses
    ```
    -> Rails automatically creates a special method:
    -> addresses_attributes=, which allows handling multiple address records at once.


    -> This means we can pass address data inside the person params, and Rails will:
      > Create new addresses when a person is created.
      > Update existing addresses when editing a person.
      > Delete addresses if specified.
    
  

  ## 9.2 Nested Forms in the View -*-*-*-*-*

    -> We want to create a Person with multiple Address records within a single form. 
    -> The user should be able to: 
      > Input details for a person (e.g., name).
      > Add multiple addresses (e.g., home, office).
      > Ensure Rails correctly processes and stores this data.

    -> Rails provides the fields_for helper, which is used to generate fields for associated
       records.
    ```
    <%= form_with model: @person do |form| %>
      Addresses:
      <ul>
        <%= form.fields_for :addresses do |addresses_form| %>
          <li>
            <%= addresses_form.label :kind %>
            <%= addresses_form.text_field :kind %>

            <%= addresses_form.label :street %>
            <%= addresses_form.text_field :street %>
          </li>
        <% end %>
      </ul>
    <% end %>
    ```

    -> The fields_for :addresses ensures that Rails automatically creates form fields for each
       address associated with the @person.
    -> If the person has no addresses, the form will not render anything.



    -> By default, if @person.addresses is empty, no address fields will appear.
    -> To ensure at least two empty address fields are always present, modify the new action in
       the controller:
    ```
    def new
      @person = Person.new
      2.times { @person.addresses.build } # Creates 2 empty addresses
    end
    ```

    -> Now, when the form is rendered, it will contain two address input sections, even if the
       person has no saved addresses.

    -> Generated HTML:
    ```
    <form action="/people" accept-charset="UTF-8" method="post"><input type="hidden" name="authenticity_token" value="lWTbg-4_5i4rNe6ygRFowjDfTj7uf-6UPFQnsL7H9U9Fe2GGUho5PuOxfcohgm2Z-By3veuXwcwDIl-MLdwFRg" autocomplete="off">
      Addresses:
      <ul>
          <li>
            <label for="person_addresses_attributes_0_kind">Kind</label>
            <input type="text" name="person[addresses_attributes][0][kind]" id="person_addresses_attributes_0_kind">

            <label for="person_addresses_attributes_0_street">Street</label>
            <input type="text" name="person[addresses_attributes][0][street]" id="person_addresses_attributes_0_street">
            ...
          </li>

          <li>
            <label for="person_addresses_attributes_1_kind">Kind</label>
            <input type="text" name="person[addresses_attributes][1][kind]" id="person_addresses_attributes_1_kind">

            <label for="person_addresses_attributes_1_street">Street</label>
            <input type="text" name="person[addresses_attributes][1][street]" id="person_addresses_attributes_1_street">
            ...
          </li>
      </ul>
    </form>
    ```


    -> When the form is submitted, the params hash will look like this:

    ```
    {
      "person" => {
        "name" => "John Doe",
        "addresses_attributes" => {
          "0" => {
            "kind" => "Home",
            "street" => "221b Baker Street"
          },
          "1" => {
            "kind" => "Office",
            "street" => "31 Spooner Street"
          }
        }
      }
    }
    ```

    -> Each address has an integer key ("0", "1"), which doesn’t matter as long as each one is
       unique.
    -> Rails will automatically create two Address records associated with the Person.


    -> If the person already has saved addresses, fields_for will generate hidden input fields
       for their IDs.
    -> This helps Rails know which records to update instead of creating new ones.

    ```
    {
      "person" => {
        "name" => "John Doe",
        "addresses_attributes" => {
          "0" => {
            "id" => "1",
            "kind" => "Home",
            "street" => "221b Baker Street"
          },
          "1" => {
            "id" => "2",
            "kind" => "Office",
            "street" => "31 Spooner Street"
          }
        }
      }
    }
    ```

    -> Rails will update addresses with id: 1 and id: 2 instead of creating new records.
    -> The hidden input field with id is automatically added by fields_for.


  
  ## 9.3 Permitting Parameters in the Controller -*-*-*-*

    -> By default, Rails has strong parameters, which means that we must explicitly permit which
       attributes can be passed to the model. 
    -> Otherwise, Rails will ignore them to prevent security issues like mass assignment.

    ```
    def create
      @person = Person.new(person_params)
      # ...
    end

    private

    def person_params
      params.require(:person).permit(:name, addresses_attributes: [:id, :kind, :street])
    end
    ```

    -> params.require(:person): Ensures that the root key is "person" in the incoming request.
    -> permit(:name, addresses_attributes: [:id, :kind, :street]): Allows name and nested 
       addresses_attributes fields to be used.
    -> Without permitting the parameters, Rails will ignore the nested attributes, and the form 
       submission won’t work.
  

  ## 9.4 Removing Associated Objects -*-*-*-*

    -> By default, nested attributes do not allow deletion, meaning we can't remove an associated
       address via the form.

    -> To enable deletion, we add allow_destroy: true to the accepts_nested_attributes_for method
       in the Person model:
    ```
    class Person < ApplicationRecord
      has_many :addresses
      accepts_nested_attributes_for :addresses, allow_destroy: true
    end
    ```

    -> Now, when a submitted form contains a _destroy key set to true, Rails will delete that
       associated address.
    

    -> To allow users to mark an address for deletion, we add a checkbox in the form:

    ```
    <%= form_with model: @person do |form| %>
      Addresses:
      <ul>
        <%= form.fields_for :addresses do |addresses_form| %>
          <li>
            <%= addresses_form.check_box :_destroy %>
            <%= addresses_form.label :kind %>
            <%= addresses_form.text_field :kind %>
          </li>
        <% end %>
      </ul>
    <% end %>
    ```

    -> Generated HTML
    ```
    <input type="checkbox" value="1" name="person[addresses_attributes][0][_destroy]" id="person_addresses_attributes_0__destroy">
    ```

    -> If the user checks this box, _destroy will be set to 1, and Rails will know to delete the
       record.
    

    -> Updating Strong Parameters in the Controller
    -> To make sure _destroy is allowed, update person_params:

    ```
    def person_params
      params.require(:person).
        permit(:name, addresses_attributes: [:id, :kind, :street, :_destroy])
    end
    ```

    -> Now, Rails can remove the Address record when _destroy: 1 is present.


  
  ## 9.5 Preventing Empty Records -*-*-*-*

    -> If the form includes empty fields, Rails will attempt to create records with blank values,
       which we usually don’t want.

    -> To prevent this, we use the reject_if option in accepts_nested_attributes_for:
    ```
    class Person < ApplicationRecord
      has_many :addresses
      accepts_nested_attributes_for :addresses, reject_if: lambda { |attributes| attributes["kind"].blank? }
    end
    ```

    -> Before creating an Address, Rails will check if kind is blank.
    -> If it’s blank, Rails will not create the address.






# 10 Forms to External Resources */*/*/*/*

  -> Sometimes, we need to submit form data to an external API instead of our Rails application.
  -> Rails' form_with helper makes this easy.

  -> If an external API requires an authenticity token, we can pass it like this:
    ```
    <%= form_with url: 'http://farfar.away/form', authenticity_token: 'external_token' do %>
      <%= label_tag :name, "Your Name" %>
      <%= text_field_tag :name %>

      <%= submit_tag "Submit" %>
    <% end %>
    ```
  
  -> The form sends data to http://farfar.away/form.
  -> Authenticity token (external_token) is included.
  -> The external API validates this token.



  -> Some APIs don't need an authenticity token. we can disable it:
    ```
    <%= form_with url: 'http://farfar.away/form', authenticity_token: false do %>
      <%= label_tag :email, "Your Email" %>
      <%= email_field_tag :email %>

      <%= submit_tag "Send" %>
    <% end %>
    ```

  -> Some external APIs reject extra fields (like authenticity_token).
  -> Prevents unnecessary parameters in the request.




# 11 Using Tag Helpers without a Form Builder */*/*/*/*
  
  -> In some cases, we might need to create form fields without using form_with or any form 
     builder. 
  -> Rails provides tag helpers that allow we to generate form elements manually.

  ```
  <%= checkbox_tag "accept" %>
  ```

  -> Output:
  ```
  <input type="checkbox" name="accept" id="accept" value="1" />
  ```
  -> Here, checkbox_tag generates a checkbox input.




# 12 Using form_tag and form_for */*/*/*

  -> Before form_with, Rails had:
    > form_tag → Used for forms without models.
    > form_for → Used for forms with models.

  -> Both are now replaced by form_with, but we might still see them in older projects.













































