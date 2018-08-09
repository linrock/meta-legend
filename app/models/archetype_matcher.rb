# Given a set of hsreplay_card_ids, find the most-likely archetype matches

require 'set'

class ArchetypeMatcher
  IGNORED_ARCHETYPES = Set.new([177])

  def initialize(card_ids, class_name)
    @card_ids = card_ids
    @class_name = class_name
    @archetype_match = ArchetypeDefinitions.new(card_ids, class_name).archetype_match
  end

  def top_match
    top_matches.first
  end

  def top_matches
    [
      @archetype_match && {
        id: @archetype_match.data["id"],
        name: @archetype_match.data["name"]
      }
    ].compact +
    all_matches
      .select {|data| !IGNORED_ARCHETYPES.include?(data[:id]) }
      .sort_by do |data|
        -data[:percent_match]
      end.take(5)
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
