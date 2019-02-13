# Replay data from all available replay data sources
# xml data, game api response

class ReplayData
  delegate :num_turns,
           to: :replay_game_api_response

  delegate :player_names, :deck_card_lists,
           to: :replay_xml_data

  def initialize(hsreplay_id)
    @hsreplay_id = hsreplay_id
  end

  def exists?
    ReplayGameApiResponse.exists?(hsreplay_id: @hsreplay_id) and
    ReplayXmlData.exists?(hsreplay_id: @hsreplay_id)
  end

  def found_at
    replay_outcome&.found_at
  end

  # merge data from replay sources into a hash
  # REQUIRED - replay xml data
  # optional - replay outcome
  # optional - replay game api response
  def to_hash
    xml = replay_xml_data.to_hash
    merged_hash = xml
    if replay_outcome
      ro = replay_outcome.to_hash
      if xml[:p1][:legend_rank] == ro[:p1][:rank] and ro[:p1][:is_legend]
        merged_hash[:p1][:archetype] = ro[:p1][:archetype]
        merged_hash[:p2][:archetype] = ro[:p2][:archetype]
        # fix missing legend ranks from xml data
        # if one of the ranks is correlated to replay outcome data
        unless merged_hash[:p2][:legend_rank].present?
          merged_hash[:p2][:legend_rank] = ro[:p2][:rank]
        end
      elsif xml[:p1][:legend_rank] == ro[:p2][:rank] and ro[:p2][:is_legend]
        merged_hash[:p1][:archetype] = ro[:p2][:archetype]
        merged_hash[:p2][:archetype] = ro[:p1][:archetype]
        # fix missing legend ranks from xml data
        # if one of the ranks is correlated to replay outcome data
        unless merged_hash[:p2][:legend_rank].present?
          merged_hash[:p2][:legend_rank] = ro[:p1][:rank]
        end
      end
    end
    deck_card_ids = xml[:deck_card_ids] || replay_xml_data.deck_card_ids
    merged_hash.delete(:deck_card_ids)
    merged_hash = merged_hash.merge({
      hsreplay_id: @hsreplay_id,
      num_turns: num_turns,
      found_at: found_at,
      deck_card_names: HearthstoneCard.card_ids_to_deck_list(deck_card_ids)
    })
    if replay_game_api_response
      opposing_deck = replay_game_api_response.opposing_deck
      if opposing_deck
        card_ids = opposing_deck["cards"] || []
        predicted_card_ids = opposing_deck["predicted_cards"] || []
        merged_hash = merged_hash.merge({
          opposing_deck: {
            cards: HearthstoneCard.card_ids_to_deck_list(card_ids),
            predicted_cards: HearthstoneCard.card_ids_to_deck_list(predicted_card_ids)
          }
        })
      end
      if !merged_hash[:p1][:archetype]
        merged_hash[:p1][:archetype] = replay_game_api_response.friendly_class_name
      end
      if !merged_hash[:p2][:archetype]
        merged_hash[:p2][:archetype] = replay_game_api_response.opposing_class_name
      end
      if !merged_hash[:found_at]
        merged_hash[:found_at] = replay_game_api_response.data["global_game"]["match_start"]
      end
      if replay_game_api_response.arena?
        merged_hash[:metadata] = replay_game_api_response.metadata
      end
    end
    merged_hash
  end

  def replay_xml_data
    @_rx ||= ReplayXmlData.find_by(hsreplay_id: @hsreplay_id)
  end

  def replay_game_api_response
    @_rg ||= ReplayGameApiResponse.find_by(hsreplay_id: @hsreplay_id)
  end

  def replay_outcome
    @_ro ||= ReplayOutcome.find_by(hsreplay_id: @hsreplay_id)
  end
end
