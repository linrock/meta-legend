# archetypes for archetype matcher based on deck-defining cards

class ArchetypeDefinitions

  def initialize(deck_card_ids, class_name)
    @deck_card_ids = deck_card_ids
    @class_name = class_name
  end

  def archetype_match
    if @class_name == "Rogue"
      deathrattle_card_ids = ["UNG_083", "BOT_286", "LOOT_161", "BOT_508"]
      if (@deck_card_ids & deathrattle_card_ids).length >= 2
        Archetype.find_by_name "Deathrattle Rogue"
      end
    end
  end

  private

  def deck_cards
    @deck_card_ids.map do |card_id|
      HearthstoneCard.find_by_id(card_id)
    end
  end
end
