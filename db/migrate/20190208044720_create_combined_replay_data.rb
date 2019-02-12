class CreateCombinedReplayData < ActiveRecord::Migration[5.2]
  def change
    create_table :combined_replay_data do |t|
      t.string :hsreplay_id, null: false
      t.jsonb :metadata, null: false, default: {}

      t.string :p1_battletag
      t.string :p1_class, null: false
      t.string :p1_archetype
      t.integer :p1_rank
      t.integer :p1_legend_rank
      t.boolean :p1_is_first
      t.boolean :p1_wins
      t.jsonb :p1_deck_card_ids, null: false, default: []
      t.jsonb :p1_pre_mulligan_card_ids, null: false, default: []
      t.jsonb :p1_post_mulligan_card_ids, null: false, default: []

      t.string :p2_battletag
      t.string :p2_class, null: false
      t.string :p2_archetype
      t.integer :p2_rank
      t.integer :p2_legend_rank
      t.boolean :p2_is_first
      t.boolean :p2_wins
      t.jsonb :p2_deck_card_ids, null: false, default: []
      t.jsonb :p2_predicted_deck_card_ids, null: false, default: []

      t.string :game_type
      t.integer :ladder_season
      t.integer :utc_offset
      t.integer :num_turns
      t.integer :duration_seconds

      t.datetime :found_at
      t.datetime :played_at
      t.timestamps null: false
    end
    add_index :combined_replay_data, :hsreplay_id, unique: true
  end
end
