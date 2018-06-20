class CreateSubmittedReplays < ActiveRecord::Migration[5.2]
  def change
    create_table :submitted_replays do |t|
      t.integer :user_id
      t.string :hsreplay_id, null: false
      t.timestamps null: false
    end
  end
end
