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

    
















