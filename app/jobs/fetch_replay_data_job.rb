class FetchReplayDataJob
  include Sidekiq::Worker

  sidekiq_options queue: :fetcher, backtrace: true

  def perform(hsreplay_id)
    importer = ReplayDataImporter.new(hsreplay_id)
    importer.import
    CacheReplayDataJob.perform_async(hsreplay_id)
  end
end
