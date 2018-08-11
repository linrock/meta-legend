# archetypes for archetype matcher based on deck-defining cards

class ArchetypeDefinitions

  def initialize(deck_card_ids, class_name)
    @deck_card_ids = deck_card_ids
    @class_name = class_name
  end

  def archetype_match
    name = archetype_name
    name && Archetype.find_by_name(name)
  end

  def archetype_name
    if @class_name == "Rogue"
      deathrattle_card_ids = ["UNG_083", "BOT_286", "LOOT_161", "BOT_508"]
      if (@deck_card_ids & deathrattle_card_ids).length >= 2
        "Deathrattle Rogue"
      end
    elsif @deck_card_ids.include?("BOT_424")
      case @class_name
        when "Priest" then "Mecha'thun Priest"
        when "Warlock" then "Mecha'thun Warlock"
        when "Druid" then "Mecha'thun Druid"
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
