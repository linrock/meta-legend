class StatsTopSubmitters
  def initialize
  end

  def recent(past_n_days)
    search_results(past_n_days)
      .facet(:p1_battletag)
      .rows.take(5).map do |f|
        [f.value, f.count]
      end
  end

  def all_time
    search_results
      .facet(:p1_battletag)
      .rows.take(10).map do |f|
        [f.value, f.count]
      end
  end

  def search_results(past_n_days = nil)
    CombinedReplayData.search do
      if past_n_days
        with(:played_at).greater_than(past_n_days.days.ago)
      end
      facet :p1_battletag
    end
  end
end
