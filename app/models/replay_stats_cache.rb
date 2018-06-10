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

  def legend_stats
    @cache.fetch cache_key do
      legend_stats!
    end
  end

  def legend_stats!
    replay_stats = ReplayStats.new(ReplayOutcome.legend_players.since(SINCE))
    players = replay_stats.most_active_players.map do |tag, count|
      [tag, {
        count: count,
        twitch_username: User.find_by_battletag(tag)&.twitch_username
      }]
    end
    results = {
      routes: replay_stats.to_route_map,
      players: players,
      about: {
        count: replay_stats.replays_count,
        since: replay_stats.oldest_replay_timestamp,
      },
    }
    @cache.write cache_key, results
    results
  end

  def cache_key
    "replay_stats:legend:v1"
  end
end
