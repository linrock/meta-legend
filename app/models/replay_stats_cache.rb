class ReplayStatsCache
  SINCE = 2.days.ago

  def initialize
    @cache = Rails.cache
  end

  def route_map
    legend_stats[:routes]
  end

  def route_map!
    legend_stats![:routes]
  end

  def legend_stats(rank = nil, region = nil)
    @cache.fetch cache_key(rank, region) do
      legend_stats!(rank, region)
    end
  end

  def legend_stats!(rank = nil, region = nil)
    replay_stats = ReplayStats.new(get_replay_outcomes(rank, region))
    players = replay_stats.most_active_players.map do |tag, count|
      [tag, {
        count: count,
        twitch_username: User.find_by_battletag(tag)&.twitch_username
      }]
    end
    results = {
      filter: rank,
      region: region,
      routes: replay_stats.to_route_map,
      players: players,
      about: {
        count: replay_stats.replays_count,
        since: replay_stats.oldest_replay_timestamp,
      },
    }
    @cache.write cache_key(rank, region), results
    results
  end

  def cache_key(rank, region)
    "replay_stats:rank=#{rank}:region=#{region}:legend"
  end

  private

  def get_replay_outcomes(rank, region)
    if rank == "top-100"
      replay_outcomes = ReplayOutcome.legend_players.since(4.days.ago)
    else
      replay_outcomes = ReplayOutcome.legend_players.since(SINCE)
    end
    case rank
      when "top-1000" then replay_outcomes = replay_outcomes.top_legend(1000)
      when "top-100" then replay_outcomes = replay_outcomes.top_legend(100)
    end
    case region
      when "americas" then replay_outcomes = replay_outcomes.with_xml_data.from_americas
      when "europe" then replay_outcomes = replay_outcomes.with_xml_data.from_europe
      when "asia" then replay_outcomes = replay_outcomes.with_xml_data.from_asia
    end
    replay_outcomes
  end
end
