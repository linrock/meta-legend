class WebhookBlob < ApplicationRecord
  delegate :hsreplay_id,
           :friendly_deck_card_ids,
           :opposing_deck_predicted_card_ids,
           :opposing_deck_card_ids,
           :p1_name, :p1_rank, :p1_legend_rank,
           :p2_name, :p2_rank, :p2_legend_rank,
           :num_turns, :winner, :valid_blob?,
           :to_replay_data,
           to: :webhook_blob_parser

  def create_replay_outcome!
    data = to_replay_outcome_data
    replay_outcome = ReplayOutcome.new({
      hsreplay_id: data[:id],
      data: data
    })
    logger.info "#{data[:id]} - creating replay outcome (webhook #{id})"
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
    friendly_archetype_matches[0][:id]
  end

  def p2_archetype_id
    opposing_archetype_matches[0][:id]
  end

  # need to merge this with the data feed somehow
  def replay_data
    parsed_replay_data = to_replay_data
    parsed_replay_data[:p1][:archetype] = friendly_archetype_matches[0][:id]
    parsed_replay_data[:p2][:archetype] = opposing_archetype_matches[0][:id]
    parsed_replay_data
  end

  def friendly_archetype_matches
    ArchetypeMatcher.new(friendly_deck_card_ids).top_matches
  end

  def opposing_archetype_matches
    card_ids = (opposing_deck_predicted_card_ids || opposing_deck_card_ids)
    ArchetypeMatcher.new(card_ids).top_matches
  end

  private

  def webhook_blob_parser
    WebhookBlobParser.new(blob)
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/webhook_blob.log")
  end
end
