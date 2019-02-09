# Represents the outcome of a replay

class ReplayOutcome < ApplicationRecord
  validate :check_hsreplay_id
  validate :check_data_format

  after_create :extract_and_save_data
  after_create :import_legend_replay_data

  delegate :player_names, to: :replay_xml_data
  delegate :num_turns, to: :replay_html_data

  scope :filter, -> (filter) do
    case filter
      when "top-100" then self.top_legend(100)
      when "top-500" then self.top_legend(500)
      when "top-1000" then self.top_legend(1000)
    end
  end

  scope :legend_players, -> do
    where("
      replay_outcomes.data ->> 'player1_legend_rank' != 'None'
      AND
      replay_outcomes.data ->> 'player2_legend_rank' != 'None'
    ")
  end

  scope :top_legend, -> (n) do
    where("
      (replay_outcomes.data ->> 'player1_legend_rank')::int <= ?
      AND
      (replay_outcomes.data ->> 'player2_legend_rank')::int <= ?
    ", n, n)
  end

  scope :with_archetypes, -> (archetype_ids) do
    where("
      (replay_outcomes.data ->> 'player1_archetype' IN (?))
      OR
      (replay_outcomes.data ->> 'player2_archetype' IN (?))
    ", *[archetype_ids.map(&:to_s)]*2)
  end

  scope :since, -> (time_ago) do
    where("replay_outcomes.created_at > ?", time_ago)
  end

  scope :with_xml_data, -> do
    joins("
      INNER JOIN replay_xml_data
      ON replay_xml_data.hsreplay_id = replay_outcomes.hsreplay_id
    ")
  end

  scope :from_americas, -> do
    where("replay_xml_data.utc_offset >= -10")
      .where("replay_xml_data.utc_offset <= -3")
  end

  scope :from_europe, -> do
    where("replay_xml_data.utc_offset >= -2")
      .where("replay_xml_data.utc_offset <= 4")
  end

  scope :from_asia, -> do
    where("replay_xml_data.utc_offset >= 5")
      .where("replay_xml_data.utc_offset <= 12")
  end

  alias_attribute :found_at, :created_at

  searchable do
    string :hsreplay_id

    integer :pilot_rank do
      player1_rank&.to_i
    end
    integer :pilot_legend_rank do
      player1_legend_rank&.to_i
    end
    # integer :pilot_class do
    #   player1_class
    # end
    # integer :pilot_archetype do
    #   arch_id = data["player1_archetype"]
    #   arch = ArchetypeCache.instance.archetypes_map[arch_id.to_s]
    #   arch.data["name"].gsub(player1_class, '').strip
    # end

    integer :opponent_rank do
      player2_rank&.to_i
    end
    integer :opponent_legend_rank do
      player2_legend_rank&.to_i
    end
    # integer :opponent_class do
    #   player2_class
    # end
    # integer :opponent_archetype do
    #   arch_id = data["player2_archetype"]
    #   arch = ArchetypeCache.instance.archetypes_map[arch_id.to_s]
    #   arch.data["name"].gsub(player1_class, '').strip
    # end

    # string :game_type do
    #   ReplayGameApiResponse
    # end
    time :created_at
  end

  def archetype_ids
    [ data["player1_archetype"], data["player2_archetype"] ]
  end

  def legend_game?
    player1_is_legend? and player2_is_legend?
  end

  def player1_class
    arch_id = data["player1_archetype"]
    arch = ArchetypeCache.instance.archetypes_map[arch_id.to_s]
    arch.data["player_class_name"].capitalize
  end

  def player1_archetype_prefix
    arch_id = data["player1_archetype"]
    arch = ArchetypeCache.instance.archetypes_map[arch_id.to_s]
    arch.data["name"].gsub(player1_class, '').strip
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

  def player2_class
    arch_id = data["player2_archetype"]
    arch = ArchetypeCache.instance.archetypes_map[arch_id.to_s]
    arch.data["player_class_name"].capitalize
  end

  def player2_archetype_prefix
    arch_id = data["player2_archetype"]
    arch = ArchetypeCache.instance.archetypes_map[arch_id.to_s]
    arch.data["name"].gsub(player1_class, '').strip
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
    extracted_data&.deep_symbolize_keys || to_hash!
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
    return unless legend_game?
    data_importer = ReplayDataImporter.new(hsreplay_id)
    return if data_importer.data_exists?
    data_importer.import_async
  end

  private

  def check_hsreplay_id
    errors.add(:hsreplay_id, "is invalid") unless hsreplay_id == data["id"]
  end

  def check_data_format
    errors.add(:data, "id is invalid") unless data["id"].to_s =~ /\A[0-9a-z]+\z/i
    unless data["player1_archetype"].to_i > 0 and data["player2_archetype"].to_i > 0
      errors.add(:data, "player archetypes are invalid")
    end
    unless %w( True False ).include? data["player2_won"]
      errors.add(:data, "player2_won is invalid")
    end
    # check_rank_consistency
  end

  def check_rank_consistency
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
  end
end
