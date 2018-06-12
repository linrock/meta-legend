class ReplayStatsCache
  SINCE = 3.days.ago

  def initialize
    @cache = Rails.cache
  end

  def route_map
    legend_stats[:routes]
  end

  def route_map!
    legend_stats![:routes]
  end

  def legend_stats(filter = nil)
    @cache.fetch cache_key(filter) do
      legend_stats!(filter)
    end
  end

  def legend_stats!(filter = nil)
    replay_stats = ReplayStats.new(get_replay_outcomes(filter))
    players = replay_stats.most_active_players.map do |tag, count|
      [tag, {
        count: count,
        twitch_username: User.find_by_battletag(tag)&.twitch_username
      }]
    end
    results = {
      filter: filter,
      routes: replay_stats.to_route_map,
      players: players,
      about: {
        count: replay_stats.replays_count,
        since: replay_stats.oldest_replay_timestamp,
      },
    }
    @cache.write cache_key(filter), results
    results
  end

  def cache_key(filter)
    "replay_stats:#{filter}:legend"
  end

  private

  def get_replay_outcomes(filter)
    replay_outcomes = ReplayOutcome.legend_players.since(SINCE)
    case filter
      when "top1000" then replay_outcomes = replay_outcomes.top_legend(1000)
      when "top100" then replay_outcomes = replay_outcomes.top_legend(100)
    end
    replay_outcomes
  end
end
