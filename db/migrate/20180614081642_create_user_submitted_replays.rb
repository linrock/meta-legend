class CreateUserSubmittedReplays < ActiveRecord::Migration[5.2]
  def change
    create_table :user_submitted_replays do |t|
      t.integer :user_id, null: false
      t.string :hsreplay_id, null: false
      t.timestamps
    end
    add_index :user_submitted_replays, [:user_id, :hsreplay_id], unique: true
  end
end
