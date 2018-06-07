class ReplayXmlData < ApplicationRecord
  validates_uniqueness_of :hsreplay_id

  def player_names
    doc.xpath("//Player/@name").map(&:value)
  end

  def winner_name
    doc.xpath("//Player[@id=#{winner_entity_id}]").attr("name").value
  end

  def loser_name
    doc.xpath("//Player[@id=#{loser_entity_id}]").attr("name").value
  end

  def pilot_name
    doc.xpath("//Deck/parent::Player").attr("name").value
  end

  def deck_card_ids
    doc.xpath("//Deck/Card/@id").map(&:value)
  end

  def winner_entity_id
    doc.xpath("//TagChange[@tag=17][@value=4]").attr("entity").value
  end

  def loser_entity_id
    doc.xpath("//TagChange[@tag=17][@value=5]").attr("entity").value
  end

  def doc
    @doc ||= Nokogiri.parse data
  end
end
