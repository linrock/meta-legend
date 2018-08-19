class WebhookBlobParser

  def initialize(webhook_blob_data)
    @data = webhook_blob_data
  end

  def valid_blob?
    return false if !PlayerClass::NAMES.include?(p1_class_name)
    return false if !PlayerClass::NAMES.include?(p2_class_name)
    begin
      json_data
      hsreplay_id
    rescue
      false
    else
      true
    end
  end

  def to_replay_data
    {
      p1: {
        name: p1_name,
        rank: p1_rank,
        legend_rank: p1_legend_rank,
      },
      p2: {
        name: p2_name,
        rank: p2_rank,
        legend_rank: p2_legend_rank,
      },
      num_turns: num_turns,
      pilot_name: p1_name,
      winner: winner,
      deck_card_ids: HearthstoneCard.card_ids_to_deck_list(
        friendly_deck_card_ids
      ),
      found_at: Time.now,
    }
  end

  def p1_name
    json_data.dig("friendly_player", "name")
  end

  def p1_class_name
    json_data.dig("friendly_player", "hero_class_name")&.capitalize
  end

  def p1_rank
    json_data.dig("friendly_player", "rank")
  end

  def p1_legend_rank
    json_data.dig("friendly_player", "legend_rank")
  end

  def p2_name
    json_data.dig("opposing_player", "name")
  end

  def p2_class_name
    json_data.dig("opposing_player", "hero_class_name")&.capitalize
  end

  def p2_rank
    json_data.dig("opposing_player", "rank")
  end

  def p2_legend_rank
    json_data.dig("opposing_player", "legend_rank")
  end

  def num_turns
    json_data.dig("global_game", "num_turns")
  end

  def winner
    if json_data.dig("friendly_player", "final_state") == 4
      'p1'
    elsif json_data.dig("opposing_player", "final_state") == 5
      'p2'
    elsif !json_data["won"].nil?
      json_data["won"] ? 'p1' : 'p2'
    else
      nil
    end
  end

  def hsreplay_id
    json_data["shortid"]
  end

  def hsreplay_url
    json_data["url"]
  end

  def friendly_deck_card_ids
    json_data["friendly_deck"]["cards"]
  end

  def opposing_deck_card_ids
    json_data["opposing_deck"]["cards"]
  end

  def opposing_deck_predicted_card_ids
    json_data["opposing_deck"]["predicted_cards"]
  end

  def json_data
    @json_data ||= JSON.parse(@data)["data"]
  end
end
