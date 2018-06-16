class CreateReplayComments < ActiveRecord::Migration[5.2]
  def change
    create_table :replay_comments do |t|
      t.string :hsreplay_id, null: false
      t.integer :user_id
      t.text :text, null: false
      t.timestamps
    end
    add_index :replay_comments, [:hsreplay_id, :user_id]
  end
end
