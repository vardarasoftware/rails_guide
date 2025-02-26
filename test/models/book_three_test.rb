require "test_helper"

class BookThreeTest < ActiveSupport::TestCase
  test "should be valid" do
    book = BookThree.new(name: "Test Book")
    assert book.valid?
  end
end
