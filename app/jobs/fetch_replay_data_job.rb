class FetchReplayDataJob < ActiveJob::Base

  def perform(hsreplay_id)
    importer = ReplayDataImporter.new(hsreplay_id)
    importer.save_html
    importer.save_xml
  end
end
