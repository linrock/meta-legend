# One set of replay data combined from different sources
#
# ReplayOutcome - replay outcomes from the hsreplay.net homepage feed
# WebhookBlob - data submitted via webhook

# ReplayGameApiResponse - data from the api response when viewing a game
# ReplayHtmlData - data from the HTML when viewing a game
# ReplayXmlData - data from the XML file when viewing a game

class CombinedReplayData < ActiveRecord::Base
  validates :hsreplay_id, presence: true
  validates :p1_class, inclusion: PlayerClass::NAMES
  validates :p2_class, inclusion: PlayerClass::NAMES
  validates :game_type, inclusion: ["standard", "wild", "arena"], allow_nil: true
  validates :ladder_season, numericality: { greater_than: 0 }, allow_nil: true
  validates :num_turns, numericality: { greater_than: 0 }, allow_nil: true
  validates :duration_seconds, numericality: { greater_than: 0 }, allow_nil: true
  validate :check_player_ranks

  searchable do
    string :p1_battletag
    string :p1_class
    string :p1_archetype
    integer :p1_rank
    integer :p1_legend_rank
    string :p1_deck_card_ids, multiple: true

    string :p2_battletag
    string :p2_class
    string :p2_archetype
    integer :p2_rank
    integer :p2_legend_rank
    string :p2_deck_card_ids, multiple: true
    string :p2_predicted_deck_card_ids, multiple: true

    string :game_type
    integer :ladder_season
    integer :utc_offset
    integer :num_turns
    integer :duration_seconds
    boolean :p1_wins

    time :played_at
  end

  private

  def check_player_ranks
  end
end

=begin
  searchable do
    text :pilot_name, :p1_name
    text :pilot_battletag, :p1_battletag
    text :pilot_class, :p1_class
    text :pilot_archetype, :p1_archetype
    integer :pilot_rank, :p1_rank
    integer :pilot_legend_rank, :p1_legend_rank
    json_facet :pilot_deck_card_ids, :p1_deck_card_ids

    text :opponent_name, :p2_name
    text :opponent_battletag, :p2_battletag
    text :opponent_class, :p2_class
    text :opponent_archetype, :p2_archetype
    integer :opponent_rank, :p2_rank
    integer :opponent_legend_rank, :p2_legend_rank
    json_facet :opponent_partial_deck_card_ids, :p2_partial_deck_card_ids
    json_facet :opponent_predicted_deck_card_ids, :p2_predicted_deck_card_ids

    text :game_mode, :game_mode
    integer :num_turns, :num_turns
    boolean :pilot_wins, :pilot_wins

    time :created_at
    time :played_at
  end
end

CombinedReplayData.search do
  pilot_class "Hunter"
  pilot_archetype "Secret"

  with(:created_at).greater_than 7.days.ago
  paginate(page: 1, per_page: 25)
end

CombinedReplayData.search do
  pilot_class "Hunter"
  pilot_archetype "Secret"

  facet(:pilot_legend_rank, range: 1..1_000)
  facet(:opponent_legend_rank, range: 1..1_000)
  with(:created_at).greater_than 7.days.ago
  order_by(:created_at, :desc)
  paginate(page: 1, per_page: 25)
end

CombinedReplayData.search do
  any_of do
    with(:pilot_legend_rank).greater_than 0
    with(:pilot_rank, range: 1..5)
    with(:opponent_legend_rank).greater_than 0
    with(:opponent_rank, range: 1..5)
  end
end
=end
