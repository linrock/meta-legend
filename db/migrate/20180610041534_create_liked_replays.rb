class CreateLikedReplays < ActiveRecord::Migration[5.2]
  def change
    create_table :liked_replays do |t|
      t.integer :user_id, null: false
      t.string :hsreplay_id, null: false
      t.timestamps
    end
    add_index :liked_replays, [:user_id, :hsreplay_id], unique: true
  end
end
