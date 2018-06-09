class CreateForumComments < ActiveRecord::Migration[5.2]
  def change
    create_table :forum_comments do |t|
      t.integer :forum_post_id, null: false
      t.integer :user_id, null: false
      t.text :content, null: false
      t.timestamps
    end
    add_index :forum_comments, :forum_post_id
    add_index :forum_comments, :user_id
  end
end
