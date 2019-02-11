# Given a set of hsreplay_card_ids, find the most-likely archetype matches

require 'set'

class ArchetypeMatcher

  # Archetypes that are no longer seen in Standard
  WILD_ARCHETYPES = Set.new([
    "Barnes Hunter",
    "C'Thun Druid",
    "C'Thun Warrior",
    "N'Zoth Priest",
    "N'Zoth Rogue",
    "N'Zoth Mage",
    "N'Zoth Paladin",
    "Demon Warlock",
    "Prince Warlock",
    "Handlock",
    "Jade Druid",
    "Highlander Priest",
    "Dragon Highlander Priest"
  ])

  def self.match_hsreplay_id(hsreplay_id)
    game_api_response = ReplayGameApiResponse.find_by(hsreplay_id: hsreplay_id)
    {
      p1: ArchetypeMatcher.new(
        game_api_response.friendly_deck["cards"],
        game_api_response.friendly_class_name,
        game_api_response.game_type
      ).top_matches,
      p2: ArchetypeMatcher.new(
        (game_api_response.opposing_deck["predicted_cards"] ||
        game_api_response.opposing_deck["cards"]),
        game_api_response.opposing_class_name,
        game_api_response.game_type
      ).top_matches
    }
  end

  def initialize(card_ids, class_name, game_type = nil)
    @card_ids = card_ids
    @class_name = class_name
    @game_type = game_type
    @archetype_match = ArchetypeDefinitions.new(
      card_ids, class_name
    ).archetype_match
  end

  def top_match
    top_matches.first
  end

  # manual match (if present) + top 5 matches ranked by % cards matched
  def top_matches
    matches = all_matches
    if @game_type == "standard"
      matches.select! {|data| !WILD_ARCHETYPES.include?(data[:name]) }
    end
    matches = matches.sort_by { |data| -data[:percent_match] }.take(5)
    if @archetype_match
      matches.unshift({
        id: @archetype_match.data["id"],
        name: @archetype_match.data["name"]
      })
    end
    matches
  end

  def all_matches
    Archetype.all.map do |archetype|
      next unless @class_name.present? && archetype.class_name == @class_name
      components = archetype.data.dig(
        "standard_ccp_signature_core",
        "components"
      )
      next unless components.present?
      num_matched = (hsreplay_card_id_set & Set.new(components)).count.to_f
      percent_match = num_matched * 100 / components.length
      {
        id: archetype.data["id"],
        name: archetype.data["name"],
        percent_match: percent_match
      }
    end.compact
  end

  private

  def hsreplay_card_id_set
    Set.new(@card_ids.map { |card_id| archetype_card_map[card_id] })
  end

  def archetype_card_map
    @archetype_card_map ||= ArchetypeCardMap.new.card_map
  end
end
