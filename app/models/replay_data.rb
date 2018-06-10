class ReplayData
  delegate :found_at,
           to: :replay_outcome

  delegate :num_turns,
           to: :replay_html_data

  delegate :player_names, :deck_card_lists,
           to: :replay_xml_data

  def initialize(hsreplay_id)
    @hsreplay_id = hsreplay_id
  end

  def exists?
    ReplayHtmlData.exists?(hsreplay_id: @hsreplay_id) and
    ReplayXmlData.exists?(hsreplay_id: @hsreplay_id)
  end

  def import_html_from_file!
    return false if replay_outcome.nil?
    return true if ReplayHtmlData.exists?(hsreplay_id: @hsreplay_id)
    ReplayHtmlData.create!({
      hsreplay_id: @hsreplay_id,
      data: open("data/#{@hsreplay_id}.html").read
    })
  end

  def import_xml_from_file!
    return false if replay_outcome.nil?
    return true if ReplayXmlData.exists?(hsreplay_id: @hsreplay_id)
    ReplayXmlData.create!({
      hsreplay_id: @hsreplay_id,
      data: open("data/#{@hsreplay_id}.xml").read
    })
  end

  # merge data from the replay outcome and xml replay data together
  def to_hash
    ro = replay_outcome.to_hash
    xml = replay_xml_data.to_hash
    merged_hash = xml
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
    deck_card_ids = xml[:deck_card_ids] || replay_xml_data.deck_card_ids
    merged_hash.delete(:deck_card_ids)
    merged_hash.merge({
      hsreplay_id: @hsreplay_id,
      num_turns: num_turns,
      found_at: found_at,
      deck_card_names: HearthstoneCard.card_ids_to_deck_list(deck_card_ids)
    })
  end

  def replay_html_data
    @replay_html_data ||= ReplayHtmlData.find_by(hsreplay_id: @hsreplay_id)
  end

  def replay_xml_data
    @replay_xml_data ||= ReplayXmlData.find_by(hsreplay_id: @hsreplay_id)
  end

  private

  def replay_outcome
    @replay_outcome ||= ReplayOutcome.find_by(hsreplay_id: @hsreplay_id)
  end
end
