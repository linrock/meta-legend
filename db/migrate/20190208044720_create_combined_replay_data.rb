class CreateCombinedReplayData < ActiveRecord::Migration[5.2]
  def change
    create_table :combined_replay_data do |t|
      t.string :hsreplay_id
      t.jsonb :metadata, null: false, default: {}

      t.string :p1_battletag
      t.string :p1_class
      t.string :p1_archetype
      t.integer :p1_rank
      t.integer :p1_legend_rank
      t.jsonb :p1_deck_card_ids

      t.string :p2_battletag
      t.string :p2_class
      t.string :p2_archetype
      t.integer :p2_rank
      t.integer :p2_legend_rank
      t.jsonb :p2_deck_card_ids
      t.jsonb :p2_predicted_deck_card_ids

      t.string :game_type
      t.integer :ladder_season
      t.integer :utc_offset
      t.integer :num_turns
      t.integer :duration_seconds
      t.boolean :p1_wins

      t.datetime :found_at
      t.datetime :played_at
      t.timestamps
    end
    add_index :combined_replay_data, :hsreplay_id, unique: true
  end
end
