# archetypes for archetype matcher based on deck-defining cards

class ArchetypeDefinitions

  def initialize(deck_card_ids, class_name)
    @deck_card_ids = deck_card_ids
    @class_name = class_name
  end

  # Returns the Archetype model matching the cards + class name
  def archetype_match
    name = archetype_name
    name && name.include?(@class_name) && Archetype.find_by_name(name)
  end

  # Returns the name of the archetype matching the cards + class name
  def archetype_name
    match_by_card || match_by_class_name
  end

  # Class-specific matches
  def match_by_class_name
    case @class_name
    when "Rogue"
      deathrattle_card_ids = ["UNG_083", "BOT_286", "LOOT_161", "BOT_508"]
      if (@deck_card_ids & deathrattle_card_ids).length >= 2
        "Deathrattle Rogue"
      end
    when "Hunter"
      if has_card?("BOT_573") # Subject 9
        "Secret Hunter"
      end
    when "Priest"
      if has_card?("BOT_567") # Zerek's Cloning Gallery
        "Clone Priest"
      else
        dragons = Set.new([
          "UNG_848", "EX1_561", "LOOT_410", "EX1_043", "TRL_569"
        ])
        if @deck_card_ids.count {|c| dragons.include?(c) } >= 5
          "Dragon Priest"
        end
      end
    when "Shaman"
      if has_card?("GIL_820") # Shudderwock
        "Shudderwock Shaman"
      end
    end
  end

  # Cards that define the deck
  def match_by_card
    if has_card?("BOT_424") # Mecha'thun
      case @class_name
        when "Priest" then "Mecha'thun Priest"
        when "Warlock" then "Mecha'thun Warlock"
        when "Druid" then "Mecha'thun Druid"
        when "Warrior" then "Mecha'thun Warrior"
      end
    elsif has_card?("GIL_826") # Baku the mooneater
      if @class_name == "Warrior" && has_card?("UNG_934")
        "Odd Quest Warrior"
      else
        "Odd #{@class_name}"
      end
    end
  end

  # Filters out clearly-wrong matches
  def filter(archetype_matches)
    quests = [
      "UNG_028", # Open the waygate
      "UNG_116", # Jungle giants
      "UNG_829", # Lakkari sacrifice
      "UNG_920", # The marsh queen
      "UNG_934", # Fire plume's heart
      "UNG_940", # Awaken the makers
      "UNG_942", # Unite the murlocs
      "UNG_954", # The last kaleidosaur
      "UNG_067", # The caverns below
    ]
    if (quests & @deck_card_ids).present?
      archetype_matches
    else
      # Don't allow Quest archetypes for decks that have no quests
      archetype_matches.select {|match| !match[:name].include?("Quest") }
    end
  end

  private

  def has_card?(card_id)
    @deck_card_ids.include?(card_id)
  end

  def deck_cards
    @deck_card_ids.map do |card_id|
      HearthstoneCard.find_by_id(card_id)
    end
  end
end
