class ReplayData
  delegate :player_names, :deck_card_lists, :has_both_decks?,
           to: :replay_xml_data

  delegate :num_turns,
           to: :replay_html_data

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

  private

  def replay_outcome
    @replay_outcome ||= ReplayOutcome.find_by(hsreplay_id: @hsreplay_id)
  end

  def replay_html_data
    @replay_html_data ||= ReplayHtmlData.find_by(hsreplay_id: @hsreplay_id)
  end

  def replay_xml_data
    @replay_xml_data ||= ReplayXmlData.find_by(hsreplay_id: @hsreplay_id)
  end
end
