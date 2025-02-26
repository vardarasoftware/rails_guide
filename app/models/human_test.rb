require "test_helper"

class HumanTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  setup do
    @model = Human.new
  end
end
