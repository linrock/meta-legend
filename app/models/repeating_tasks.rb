class RepeatingTasks

  def import_replays
    ReplayOutcomeImporter.new.keep_fetching
  end

  def import_replay_data
    loop do
      ReplayDataImporter.import_missing_data!
      sleep 1.minute
    end
  end

  def calculate_legend_stats
    loop do
      t0 = Time.now
      cache = ArchetypeCache.new
      cache.archetypes_map!
      route_map = RouteMap.new
      route_map.to_hash!
      ReplayStatsCache.new.legend_stats!
      ReplayStatsCache.new.legend_stats! "top100"
      ReplayStatsCache.new.legend_stats! "top1000"
      logger.info "#{Time.now - t0}s to refresh archetype + legend stats caches"
      sleep 15.minutes
    end
  end

  def warm_json_response_caches
    loop do
      t0 = Time.now
      JsonResponseCache.warm_all_caches!
      logger.info "#{Time.now - t0}s to refresh json caches"
      sleep 2.minutes
    end
  end

  private

  def logger
    STDOUT.sync = true
    @logger ||= Logger.new(STDOUT)
  end
end
