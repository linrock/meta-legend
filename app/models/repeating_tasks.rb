class RepeatingTasks

  def import_replays
    ReplayOutcomeImporter.new.keep_fetching
  end

  def import_replay_data
    loop do
      ReplayDataImporter.import_missing_data!
      sleep 60
    end
  end

  def calculate_legend_stats
    loop do
      cache = ArchetypeCache.new
      cache.archetypes_map!
      route_map = RouteMap.new
      route_map.to_hash!
      ReplayStatsCache.new.legend_stats!
      sleep 3600
    end
  end

  def warm_json_response_caches
    loop do
      t0 = Time.now
      JsonResponseCache.warm_all_caches!
      puts "Refreshing json caches took #{Time.now - t0}s"
      sleep 120
    end
  end
end
