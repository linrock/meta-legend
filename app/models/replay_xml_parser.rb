class ReplayXmlParser

  def initialize(xml_data)
    @xml_data = xml_data
  end

  def doc
    @doc ||= Nokogiri.parse @xml_data
  end

  def players
    doc.xpath("//Player")
  end

  def player_names
    # doc.xpath("//Player/@name").map(&:value)
    players.map {|p| p.attr("name") }
  end

  # since the legend rank for a player in the replay is sometimes nil
  # when it's not nil in the replay outcome
  def player_legend_ranks
    players.map {|p| p.attr("legendRank") }
  end

  def winner_name
    if winner_entity_id
      doc.xpath("//Player[@id=#{winner_entity_id}]").attr("name").value
    else
      nil
    end
  end

  def loser_name
    if loser_entity_id
      doc.xpath("//Player[@id=#{loser_entity_id}]").attr("name").value
    else
      nil
    end
  end

  def pilot_name
    doc.xpath("//Deck/parent::Player").attr("name").value rescue nil
  end

  def deck_card_ids
    doc.xpath("//Deck/Card/@id").map(&:value)
  end

  def hsreplay_xml?
    doc.xpath('name(/*)').downcase == 'hsreplay'
  end

  private

  def winner_entity_id
    tag = doc.xpath("//TagChange[@tag=17][@value=4]")
    tag.present? && tag.attr("entity").value
  end

  def loser_entity_id
    tag = doc.xpath("//TagChange[@tag=17][@value=5]")
    tag.present? && tag.attr("entity").value
  end
end
