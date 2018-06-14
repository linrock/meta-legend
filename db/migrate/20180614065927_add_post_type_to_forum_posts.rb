class AddPostTypeToForumPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :forum_posts, :post_type, :string
  end
end
