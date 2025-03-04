atom_feed do |feed|
  feed.title("Latest Blog Posts")
  feed.updated(@blog_posts.first.created_at)

  @blog_posts.each do |post|
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.content(post.content, type: "html")

      entry.updated(post.updated_at)
      entry.published(post.created_at)
      entry.link(href: blog_post_url(post))
    end
  end
end
