class WebhookBlob < ApplicationRecord
  delegate :friendly_deck_card_ids,
           :opposing_deck_predicted_card_ids,
           :to_replay_data,
           to: :webhook_blob_parser

  # need to merge this with the data feed somehow
  def replay_data
    parsed_replay_data = to_replay_data
    parsed_replay_data[:p1][:archetype] = friendly_archetype[0][:name]
    parsed_replay_data[:p2][:archetype] = opposing_archetype[0][:name]
    parsed_replay_data
  end

  def friendly_archetype
    ArchetypeMatcher.new(friendly_deck_hsreplay_card_ids).top_matches
  end

  def opposing_archetype
    ArchetypeMatcher.new(opposing_deck_predicted_hsreplay_card_ids).top_matches
  end

  private

  def friendly_deck_hsreplay_card_ids
    friendly_deck_card_ids.map do |card_id|
      archetype_card_map[card_id]
    end
  end

  def opposing_deck_predicted_hsreplay_card_ids
    opposing_deck_predicted_card_ids.map do |card_id|
      archetype_card_map[card_id]
    end
  end

  def archetype_card_map
    @archetype_card_map ||= ArchetypeCardMap.new.card_map
  end

  def webhook_blob_parser
    WebhookBlobParser.new(blob)
  end
end
