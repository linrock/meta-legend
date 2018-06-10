class AddTwitchAndForumUsernamesToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :twitch_username, :string
    add_column :users, :forum_username, :string, unique: true
    execute "CREATE UNIQUE INDEX index_users_on_lowercase_forum_username
             ON users USING btree (LOWER(forum_username));".gsub(/\s+/, ' ')
  end

  def down
    execute "DROP INDEX index_users_on_lowercase_forum_username;"
    remove_column :users, :forum_username, :string, unique: true
    remove_column :users, :twitch_username, :string
  end
end
