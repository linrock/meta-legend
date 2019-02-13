# Popular decks widget in sidebar of /beta page

class StatsPopularDecks
  def initialize
  end

  def standard_stats
    search_results(:standard)
      .facet(:p1_class_and_archetype)
      .rows.take(5).map do |f|
        [f.value, f.count]
      end
  end

  def wild_stats
    search_results(:wild)
      .facet(:p1_class_and_archetype)
      .rows.take(5).map do |f|
        [f.value, f.count]
      end
  end

  # games played by rank 5+ players since the past week
  def search_results(game_type)
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
      with(:played_at).greater_than(1.week.ago)
      with(:game_type, game_type)
      facet :p1_class_and_archetype
    end
  end
end
