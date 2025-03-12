require "test_helper"

class BlogPostTest < ActiveSupport::TestCase
  test "should generate correct blog post show path" do
    assert_generates "/blog_posts/1", { controller: "blog_posts", action: "show", id: "1" }
  end
end
