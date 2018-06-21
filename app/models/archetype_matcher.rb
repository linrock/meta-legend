# Given a set of hsreplay_card_ids, find the most-likely archetype match

class ArchetypeMatcher

  def initialize(hsreplay_card_ids)
    @hsreplay_card_ids = Set.new(hsreplay_card_ids)
  end

  def top_matches
    all_matches.sort_by do |data|
      -data[:percent_match]
    end.take(5)
  end

  def all_matches
    Archetype.all.map do |archetype|
      components = archetype.data.dig("standard_ccp_signature_core", "components")
      next unless components.present?
      num_matched = (@hsreplay_card_ids & Set.new(components)).count.to_f
      percent_match = num_matched * 100 / components.length
      {
        name: archetype.data["name"],
        percent_match: percent_match
      }
    end.compact
  end
end
