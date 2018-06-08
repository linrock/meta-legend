# Represents the outcome of a replay

class ReplayOutcome < ApplicationRecord
  validates_uniqueness_of :hsreplay_id

  validate :check_hsreplay_id
  validate :check_data_format

  after_create :extract_and_save_data
  after_save :import_legend_replay_data

  delegate :player_names, to: :replay_xml_data
  delegate :num_turns, to: :replay_html_data

  scope :filter, -> (filter) do
    case filter
      when "top100" then self.top_legend(100)
      when "top1000" then self.top_legend(1000)
    end
  end

  scope :legend_players, -> do
    where("
      data ->> 'player1_legend_rank' != 'None'
      AND
      data ->> 'player2_legend_rank' != 'None'
    ")
  end

  scope :top_legend, -> (n) do
    where("
      (data ->> 'player1_legend_rank')::int <= ?
      AND
      (data ->> 'player2_legend_rank')::int <= ?
    ", n, n)
  end

  scope :since, -> (time_ago) do
    where("created_at > ?", time_ago)
  end

  alias_attribute :found_at, :created_at

  def archetype_ids
    [ data["player1_archetype"], data["player2_archetype"] ]
  end

  def legend_game?
    player1_is_legend? and player2_is_legend?
  end

  def player1_archetype
    Archetype.name_of_archetype_id data["player1_archetype"]
  end

  def player1_is_legend?
    data["player1_legend_rank"] != "None"
  end

  def player1_won?
    data["player2_won"] == "False"
  end

  def player1_rank
    data["player1_rank"] != "None" ? data["player1_rank"] : nil
  end

  def player1_legend_rank
    player1_is_legend? ? data["player1_legend_rank"] : nil
  end

  def player2_archetype
    Archetype.name_of_archetype_id data["player2_archetype"]
  end

  def player2_is_legend?
    data["player2_legend_rank"] != "None"
  end

  def player2_won?
    data["player2_won"] == "True"
  end

  def player2_rank
    data["player2_rank"] != "None" ? data["player2_rank"] : nil
  end

  def player2_legend_rank
    player2_is_legend? ? data["player2_legend_rank"] : nil
  end

  def replay_string
    p1_rank = data["player1_rank"].to_s
    player1 = [
      player1_archetype,
      p1_rank.to_i > 0 ? "(rank #{data["player1_rank"]})"
                  : "(legend #{data["player1_legend_rank"]})"
    ].join(" ")
    p2_rank = data["player2_rank"].to_s
    player2 = [
      player2_archetype,
      p2_rank.to_i > 0 ? "(rank #{data["player2_rank"]})"
                       : "(legend #{data["player2_legend_rank"]})"
    ].join(" ")
    "#{player1} vs #{player2}"
  end

  def replay_link
    "https://hsreplay.net/replay/#{hsreplay_id}"
  end

  def to_hash
    extracted_data.deep_symbolize_keys || to_hash!
  end

  def to_hash!
    {
      p1: {
        archetype: player1_archetype,
        is_legend: player1_is_legend?,
        rank: player1_is_legend? ? player1_legend_rank : player1_rank,
      },
      p2: {
        archetype: player2_archetype,
        is_legend: player2_is_legend?,
        rank: player2_is_legend? ? player2_legend_rank : player2_rank,
      },
      winner: player1_won? ? 'p1' : 'p2',
      hsreplay_id: hsreplay_id,
      found_at: created_at,
    }
  end

  def extract_and_save_data
    self.extracted_data = to_hash!
    self.save!
  end

  def import_legend_replay_data
    return unless legend_game? || ReplayXmlData.exists?(hsreplay_id: hsreplay_id)
    ReplayDataImporter.new(hsreplay_id).import_async
  end

  private

  def check_hsreplay_id
    errors.add(:hsreplay_id, "is invalid") unless hsreplay_id == data["id"]
  end

  def check_data_format
    errors.add(:data, "id is invalid") unless data["id"].to_s =~ /\A[0-9a-z]+\z/i
    p1_rank, p1_legend_rank, p2_rank, p2_legend_rank = ranks = [
      data["player1_rank"], data["player1_legend_rank"],
      data["player2_rank"], data["player2_legend_rank"]
    ]
    ranks.each do |rank|
      errors.add(:data, "player_ranks are invalid") unless rank == "None" || rank.to_i > 0
    end
    if ((p1_rank == "None" && p1_legend_rank == "None") ||
        (p1_rank.to_i > 0 && p1_legend_rank.to_i > 0) ||
        (p2_rank == "None" && p2_legend_rank == "None") ||
        (p2_rank.to_i > 0 && p2_legend_rank.to_i > 0))
      errors.add(:data, "player ranks are invalid")
    end
    unless data["player1_archetype"].to_i > 0 and data["player2_archetype"].to_i > 0
      errors.add(:data, "player archetypes are invalid")
    end
    unless %w( True False ).include? data["player2_won"]
      errors.add(:data, "player2_won is invalid")
    end
  end
end
