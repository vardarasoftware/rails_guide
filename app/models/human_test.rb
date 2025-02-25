require "test_helper"

class PersonTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  setup do
    @model = Person.new
  end
end
