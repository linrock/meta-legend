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
    ActiveRecord::Base.logger.silence do
      loop do
        t0 = Time.now
        cache = ArchetypeCache.new
        cache.archetypes_map!
        route_map = RouteMap.new
        route_map.to_hash!
        logger.info "#{Time.now - t0}s to refresh archetypes + route map"
        t0 = Time.now
        [nil, "top-100", "top-500", "top-1000"].each do |rank|
          [nil, "americas", "europe", "asia"].each do |region|
            ReplayStatsCache.new.legend_stats! rank, region
          end
        end
        logger.info "#{Time.now - t0}s to refresh legend stats caches"
        sleep 15.minutes
      end
    end
  end

  def warm_json_response_caches
    ActiveRecord::Base.logger.silence do
      loop do
        t0 = Time.now
        JsonResponseCache.warm_all_caches!
        logger.info "#{Time.now - t0}s to refresh json caches"
        sleep 2.minutes
      end
    end
  end

  private

  def logger
    return @logger if defined? @logger
    STDOUT.sync = true
    @logger = Logger.new(STDOUT)
  end
end
