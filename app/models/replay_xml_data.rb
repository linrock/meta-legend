class ReplayXmlData < ApplicationRecord
  validates_uniqueness_of :hsreplay_id

  def player_names
    doc.xpath("//Player").map {|p| p.attributes["name"].value }
  end

  def deck_card_lists
    doc.xpath("//Deck").map(&:children)
  end

  def has_both_decks?
    deck_card_lists.length == 2
  end

  def doc
    @doc ||= Nokogiri.parse data
  end
end
