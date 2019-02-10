# One set of replay data combined from different sources
#
# ReplayOutcome - replay outcomes from the hsreplay.net homepage feed
# WebhookBlob - data submitted via webhook

# ReplayGameApiResponse - data from the api response when viewing a game
# ReplayHtmlData - data from the HTML when viewing a game
# ReplayXmlData - data from the XML file when viewing a game

class CombinedReplayData < ActiveRecord::Base
  validates :hsreplay_id, presence: true
  validates :game_type, inclusion: ["standard", "wild", "arena"]
  validates :p1_battletag, presence: true, format: { with: /\A.*#\d+\z/ }
  validates :p2_battletag, presence: true, format: { with: /\A.*#\d+\z/ }
  validates :p1_class, inclusion: PlayerClass::NAMES
  validates :p2_class, inclusion: PlayerClass::NAMES
  validates :p1_deck_card_ids, length: { is: 30 }
  validates :ladder_season,
    numericality: { greater_than: 0 }, allow_nil: true
  validates :num_turns, numericality: { greater_than: 0 }
  validates :duration_seconds, numericality: { greater_than: 0 }
  validate :check_player_ranks

  searchable do
    string :hsreplay_id
    string :p1_battletag
    string :p1_name do
      p1_battletag.split("#").first
    end
    string :p1_class
    string :p1_archetype
    integer :p1_rank
    integer :p1_legend_rank
    string :p1_deck_card_ids, multiple: true

    string :p2_battletag
    string :p2_name do
      p2_battletag.split("#").first
    end
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
    ranks = [p1_rank, p1_legend_rank, p2_rank, p2_legend_rank]
    ranks.each do |rank|
      errors[:base] << "player rank is invalid" unless rank.nil? || rank.to_i > 0
    end
    if ((p1_rank.nil? && p1_legend_rank.nil?) ||
        (p1_rank.to_i > 0 && p1_legend_rank.to_i > 0))
      errors[:base] << "player 1 rank values are invalid"
    end
    if ((p2_rank.nil? && p2_legend_rank.nil?) ||
        (p2_rank.to_i > 0 && p2_legend_rank.to_i > 0))
      errors[:base] << "player 2 rank values are invalid"
    end
  end
end

=begin
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
