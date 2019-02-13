# Combines replay data from
# ReplayOutcome, ReplayXmlData, ReplayGameApiResponse

class CombineReplayDataJob
  include Sidekiq::Worker

  sidekiq_options queue: :default, backtrace: true

  def perform(hsreplay_id)
    migrator = CombinedReplayDataMigrator.new(hsreplay_id)
    migrator.migrate!
  end
end
