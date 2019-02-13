# Fetches replay data from hsreplay.net - xml, html, game api

class FetchReplayDataJob
  include Sidekiq::Worker

  sidekiq_options queue: :fetcher, backtrace: true

  def perform(hsreplay_id)
    importer = ReplayDataImporter.new(hsreplay_id)
    importer.import
    importer = ReplayGameApiResponseImporter.new(hsreplay_id)
    importer.import
  end
end
