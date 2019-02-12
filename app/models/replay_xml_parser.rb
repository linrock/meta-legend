class ReplayXmlParser

  def initialize(xml_data)
    @xml_data = xml_data
  end

  def doc
    @doc ||= Nokogiri.parse @xml_data
  end

  def played_at
    doc.xpath("//Game").attr("ts").value rescue nil
  end

  def players
    doc.xpath("//Player")
  end

  def player_names
    # doc.xpath("//Player/@name").map(&:value)
    players.map {|p| p.attr("name") }
  end

  # the legend rank for a player in the replay is sometimes nil here
  # when it's not nil in the replay outcome or game api response
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

  # card ids held by the pilot before the mulligan
  def pilot_pre_mulligan_hand
    doc.xpath('//Game/Block[@entity=1][1]/ShowEntity/@cardID').map(&:value)
  end

  # cards held by the pilot after the mulligan
  # entity 1 = game, entities 2 and 3 = the two players
  def pilot_post_mulligan_hand
    # list of pilot's cards. Each item's keys: "entity", "cardID"
    cards = doc.xpath('//Game/Block[@entity=1][1]/ShowEntity').map do |node|
      Hash[node.attributes.map {|k,v| [k,v.value] }]
    end
    # entity ids of cards kept after mulligan by both players
    kept_entity_ids = doc
      .xpath('//Game/Block[@entity=1][2]/ChosenEntities/Choice/@entity')
      .map(&:value)
    cards_kept = cards
      .select {|c| kept_entity_ids.include?(c["entity"]) }
      .map {|c| c["cardID"] }
    # card ids drawn by both players after mulligan
    cards_drawn = [
      doc.xpath('//Game/Block[@entity=2][1]/ShowEntity/@cardID'),
      doc.xpath('//Game/Block[@entity=3][1]/ShowEntity/@cardID')
    ].flatten.map(&:value)
    # cards held after the mulligan
    cards_kept + cards_drawn
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
