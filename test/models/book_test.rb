class BookTest < ActiveSupport::TestCase
  set_fixture_class my_books: Book
  fixtures :my_books
  # ...
end
