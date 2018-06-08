class CacheReplayDataJob
  include Sidekiq::Worker

  sidekiq_options queue: :cacher, backtrace: true

  def perform(hsreplay_id)
    ReplayDataCache.new.replay_data_hash(hsreplay_id)
  end
end
