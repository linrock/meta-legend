class ReplayData

  def initialize(replay_xml)
    @replay_xml = replay_xml
  end

  def player_names
    doc.xpath("//Player").map {|p| p.attributes["name"].value }
  end

  def deck_card_lists
    doc.xpath("//Deck").map(&:children)
  end

  def has_both_decks?
    deck_card_lists.length == 2
  end

  private

  def doc
    @doc ||= Nokogiri.parse @replay_xml
  end
end
