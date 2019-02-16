# Card frequency in sidebar of /cards/:card pages

class StatsCardFrequency
  def initialize(card_id)
    @card_id = card_id
  end

  def stats(use_p2_stats = true)
    return @stats if defined? @stats
    card_id = @card_id
    archetype_counts = CombinedReplayData.search do
      all do
        any_of do
          with(:p1_rank).between(1..5)
          without(:p1_legend_rank, nil)
        end
        any_of do
          with(:p2_rank).between(1..5)
          without(:p2_legend_rank, nil)
        end
      end
      with(:played_at).greater_than(5.days.ago)
      with(:game_type, "standard")
      with(:p1_deck_card_ids, card_id)
      facet :p1_class_and_archetype
    end.facet(:p1_class_and_archetype).rows
      .map {|row| [row.value, row.count] }.to_h
    if use_p2_stats
      CombinedReplayData.search do
        all do
          any_of do
            with(:p1_rank).between(1..5)
            without(:p1_legend_rank, nil)
          end
          any_of do
            with(:p2_rank).between(1..5)
            without(:p2_legend_rank, nil)
          end
        end
        with(:played_at).greater_than(5.days.ago)
        with(:game_type, "standard")
        with(:p2_predicted_deck_card_ids, card_id)
        facet :p2_class_and_archetype
      end.facet(:p2_class_and_archetype).rows.each do |row|
        archetype_counts[row.value] ||= 0
        archetype_counts[row.value] += row.count
      end
    end
    @stats = archetype_counts.to_a.sort_by {|x| -x[1] }.take(5)
  end

  def total_count
    stats.map(&:last).sum
  end
end
