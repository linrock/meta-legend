class ReplayData
  delegate :player_names, :deck_card_lists, :has_both_decks?,
           to: :replay_xml_data

  def initialize(hsreplay_id)
    @hsreplay_id = hsreplay_id
  end

  def exists?
    File.exists?("data/#{@hsreplay_id}.html") and
    File.exists?("data/#{@hsreplay_id}.xml")
  end

  def player_names
    replay_xml_data.player_names
  end

  private

  def replay_xml_data
    @replay_xml_data ||= ReplayXmlData.new(open("data/#{@hsreplay_id}.xml").read)
  end
end
