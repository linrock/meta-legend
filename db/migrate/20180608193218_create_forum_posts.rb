class CreateForumPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :forum_posts do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.string :content, null: false
      t.timestamps
    end
    add_index :forum_posts, :user_id
  end
end
