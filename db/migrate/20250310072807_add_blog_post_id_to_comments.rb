class AddBlogPostIdToComments < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :blog_post, null: true, foreign_key: true
  end
end
