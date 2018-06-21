class WebhookBlob < ApplicationRecord
  delegate :hsreplay_id,
           :friendly_deck_card_ids,
           :opposing_deck_predicted_card_ids,
           :opposing_deck_card_ids,
           :winner,
           :p1_rank, :p1_legend_rank,
           :p2_rank, :p2_legend_rank,
           :to_replay_data,
           to: :webhook_blob_parser

  def create_replay_outcome!
    data = to_replay_outcome_data
    replay_outcome = ReplayOutcome.new({
      hsreplay_id: data[:id],
      data: data
    })
    replay_outcome.save!
  end

  def to_replay_outcome_data
    {
      id: hsreplay_id,
      player1_won: winner == 'p1' ? "True" : "False",
      player2_won: winner == 'p2' ? "True" : "False",
      player1_rank: p1_rank ? p1_rank.to_s : "None",
      player2_rank: p2_rank ? p1_rank.to_s : "None",
      player1_archetype: p1_archetype_id,
      player2_archetype: p2_archetype_id,
      player1_legend_rank: p1_legend_rank ? p1_legend_rank.to_s : "None",
      player2_legend_rank: p2_legend_rank ? p2_legend_rank.to_s : "None",
      source: "webhook #{id}",
    }
  end

  def p1_archetype_id
    Archetype.id_by_archetype_name(friendly_archetype[0][:name])
  end

  def p2_archetype_id
    Archetype.id_by_archetype_name(opposing_archetype[0][:name])
  end

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
    ArchetypeMatcher.new(opposing_deck_hsreplay_card_ids).top_matches
  end

  private

  def friendly_deck_hsreplay_card_ids
    friendly_deck_card_ids.map do |card_id|
      archetype_card_map[card_id]
    end
  end

  def opposing_deck_hsreplay_card_ids
    ids = (opposing_deck_predicted_card_ids || opposing_deck_card_ids)
    ids.map do |card_id|
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
