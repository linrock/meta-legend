# data from the game api endpoint - /api/v1/games/:hsreplay_id

class ReplayGameApiResponse < ApplicationRecord
  validates_uniqueness_of :hsreplay_id
  validate :check_data_format

  scope :arena, -> do
    where("data -> 'global_game' -> 'game_type' = '3'")
    .order("data -> 'global_game' -> 'match_end' DESC")
  end

  scope :wild, -> do
    where("data -> 'global_game' -> 'game_type' = '30'")
    .order("data -> 'global_game' -> 'match_end' DESC")
  end

  def game_type
    case data["global_game"]["game_type"]
    when 2
      "standard"
    when 3
      "arena"
    when 30
      "wild"
    end
  end

  def ladder_season
    data["global_game"]["ladder_season"].to_i
  end

  def played_at
    DateTime.iso8601 data["global_game"]["match_start"]
  end

  def ended_at
    DateTime.iso8601 data["global_game"]["match_end"]
  end

  def duration_seconds
    ended_at.to_i - played_at.to_i
  end

  def num_turns
    data["global_game"]["num_turns"].to_i
  end

  def friendly_deck
    data["friendly_deck"]
  end

  def opposing_deck
    data["opposing_deck"]
  end

  def friendly_class_name
    data["friendly_player"]["hero_class_name"].capitalize
  end

  def friendly_rank
    data["friendly_player"]["rank"]&.to_i
  end

  def friendly_legend_rank
    data["friendly_player"]["legend_rank"]&.to_i
  end

  def opposing_class_name
    data["opposing_player"]["hero_class_name"].capitalize
  end

  def opposing_rank
    data["opposing_player"]["rank"]&.to_i
  end

  def opposing_legend_rank
    data["opposing_player"]["legend_rank"]&.to_i
  end

  def arena?
    data["global_game"]["game_type"] == 3
  end

  def metadata
    if arena?
      {
        wins: data["friendly_player"]["wins"] || 0,
        losses: data["friendly_player"]["losses"] || 0,
      }
    end
  end

  private

  def check_data_format
    %w(
      build
      shortid
      friendly_deck
      friendly_player
      opposing_deck
      opposing_player
      replay_xml
      shortid
    ).each do |data_key|
      errors.add(:data, "#{data_key} is missing") unless data[data_key].present?
    end
    if data["shortid"] != hsreplay_id
      errors.add(:data, "shortid doesn't match #{hsreplay_id}")
    end
  end
end
