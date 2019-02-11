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
  validates :p1_archetype, format: { without: PlayerClass::REGEX }
  validates :p2_archetype, format: { without: PlayerClass::REGEX }
  validates :p1_deck_card_ids, length: { is: 30 }
  validates :ladder_season,
    numericality: { greater_than: 0 }, allow_nil: true
  validates :num_turns, numericality: { greater_than: 0 }
  validates :duration_seconds, numericality: { greater_than: 0 }
  validate :validate_player_ranks

  searchable do
    string :hsreplay_id

    # p1 is the pilot
    string :p1_battletag
    string :p1_name do
      p1_battletag.split("#").first
    end
    string :p1_class
    string :p1_archetype
    string :p1_class_and_archetype do
      p1_archetype ? "#{p1_archetype} #{p1_class}" : nil
    end
    integer :p1_rank
    integer :p1_legend_rank
    string :p1_deck_card_ids, multiple: true
    boolean :p1_is_first
    boolean :p1_wins

    # p1 is the opponent
    string :p2_battletag
    string :p2_name do
      p2_battletag.split("#").first
    end
    string :p2_class
    string :p2_archetype
    string :p2_class_and_archetype do
      p2_archetype ? "#{p2_archetype} #{p2_class}" : nil
    end
    integer :p2_rank
    integer :p2_legend_rank
    string :p2_deck_card_ids, multiple: true
    string :p2_predicted_deck_card_ids, multiple: true
    boolean :p2_is_first
    boolean :p2_wins

    string :game_type
    integer :ladder_season
    integer :utc_offset
    integer :num_turns
    integer :duration_seconds

    time :played_at
  end

  # Gets the top archetype matches for p1 and p2
  # Does not classify p2 if not enough cards in the deck
  def archetype_matches
    matches = {}
    matches[:p1] = ArchetypeMatcher.new(
      p1_deck_card_ids, p1_class, game_type
    ).top_matches
    card_ids = p2_predicted_deck_card_ids || p2_deck_card_ids
    if card_ids.length >= 8
      matches[:p2] = ArchetypeMatcher.new(
        card_ids, p2_class, game_type
      ).top_matches
    end
    matches
  end

  def update_archetypes_from_matches
    matches = archetype_matches
    p1_archetype = matches[:p1].first.gsub(p1_class, '').strip
    p2_archetype = matches[:p2].first.gsub(p2_class, '').strip
    save!
  end

  # Data structure should match ReplayData#to_hash
  def as_json(options = {})
    {
      hsreplay_id: hsreplay_id,
      num_turns: num_turns,
      deck_card_names: HearthstoneCard.card_ids_to_deck_list(p1_deck_card_ids),
      opposing_deck: {
        cards: HearthstoneCard.card_ids_to_deck_list(p2_deck_card_ids),
        predicted_cards: HearthstoneCard.card_ids_to_deck_list(
          p2_predicted_deck_card_ids
        )
      },
      p1: {
        tag: p1_battletag,
        rank: p1_rank,
        legend_rank: p1_legend_rank,
        is_legend: !p1_legend_rank.nil?,
        archetype: "#{p1_archetype} #{p1_class}".strip,
      },
      p2: {
        tag: p2_battletag,
        rank: p2_rank,
        legend_rank: p2_legend_rank,
        archetype: "#{p2_archetype} #{p2_class}".strip,
      },
      winner: p1_wins ? 'p1' : 'p2',
      metadata: metadata,
      found_at: found_at
    }
  end

  private

  def validate_player_ranks
    ranks = [p1_rank, p1_legend_rank, p2_rank, p2_legend_rank]
    ranks.each do |rank|
      errors[:base] << "player rank is invalid" unless rank.nil? || rank.to_i > 0
    end
    if game_type == "standard" || game_type == "wild"
      unless ((p1_rank.nil? && p1_legend_rank.to_i > 0) ||
          (p1_rank.to_i > 0 && p1_legend_rank.nil?))
        errors[:base] << "player 1 rank values are invalid - #{p1_rank}, #{p1_legend_rank}"
      end
      unless ((p2_rank.nil? && p2_legend_rank.to_i > 0) ||
          (p2_rank.to_i > 0 && p2_legend_rank.nil?))
        errors[:base] << "player 2 rank values are invalid - #{p2_rank}, #{p2_legend_rank}"
      end
    end
  end
end
