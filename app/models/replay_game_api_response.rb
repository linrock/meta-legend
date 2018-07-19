# data from the game api endpoint - /api/v1/games/:hsreplay_id

class ReplayGameApiResponse < ApplicationRecord
  validates_uniqueness_of :hsreplay_id
  validate :check_data_format

  def opponent_partial_deck_ids
    opposing_deck["cards"]
  end

  def opponent_predicted_deck_ids
    opposing_deck["predicted_cards"]
  end

  private

  def opposing_deck
    data["opposing_deck"]
  end

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
