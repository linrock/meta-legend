class CreateReplayGameApiReponses < ActiveRecord::Migration[5.2]
  def change
    create_table :replay_game_api_responses do |t|
      t.string :hsreplay_id, null: false
      t.jsonb :data, null: false
      t.timestamps null: false
    end
    add_index :replay_game_api_responses, :hsreplay_id, unique: true
  end
end
