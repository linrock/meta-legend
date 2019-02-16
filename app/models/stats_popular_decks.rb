# Popular decks widget in sidebar of /beta page

class StatsPopularDecks
  def initialize
  end

  # use p1 and p2 class and archetypes
  def standard_stats(use_p2_stats = true)
    results = search_results(:standard)
    counts = Hash.new(0)
    results.facet(:p1_class_and_archetype).rows.each do |f|
      counts[f.value] = f.count
    end
    if use_p2_stats
      results.facet(:p2_class_and_archetype).rows.each do |f|
        counts[f.value] += f.count
      end
    end
    counts.sort_by {|_, counts| -counts }.take(5)
  end

  # use p1 and p2 class and archetypes
  def wild_stats(use_p2_stats = true)
    results = search_results(:wild)
    counts = Hash.new(0)
    results.facet(:p1_class_and_archetype).rows.each do |f|
      counts[f.value] = f.count
    end
    if use_p2_stats
      results.facet(:p2_class_and_archetype).rows.each do |f|
        counts[f.value] += f.count
      end
    end
    counts.sort_by {|_, counts| -counts }.take(5)
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
      with(:played_at).greater_than(5.days.ago)
      with(:game_type, game_type)
      facet :p1_class_and_archetype
      facet :p2_class_and_archetype
    end
  end
end
