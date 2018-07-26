class AddIndexOnReplayGameApiResponsesGameType < ActiveRecord::Migration[5.2]
  def change
    add_index :replay_game_api_responses, 
      "(data -> 'global_game' -> 'game_type')",
      name: 'index_replay_game_api_responses_on_game_type'
  end
end
