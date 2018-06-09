require 'open-uri'

class ReplayDataImporter

  def self.import_missing_data!(since = 3.days.ago)
    ReplayOutcome.legend_players.since(since).find_each do |r|
      importer = self.new(r.hsreplay_id)
      next if importer.data_exists?
      importer.import
    end
  end

  def self.import_missing_data_async!(since = 1.day.ago)
    ReplayOutcome.legend_players.since(since).find_each do |r|
      importer = self.new(r.hsreplay_id)
      next if importer.data_exists?
      importer.import_async
    end
  end

  def initialize(hsreplay_id)
    @hsreplay_id = hsreplay_id
  end

  def import
    save_html
    save_xml
  end

  def import!
    save_html!
    save_xml!
  end

  def import_async
    FetchReplayDataJob.perform_async(@hsreplay_id)
  end

  def data_exists?
    html_exists? and xml_exists?
  end

  def html_exists?
    ReplayHtmlData.exists?(hsreplay_id: @hsreplay_id)
  end

  def save_html
    logger.info "Importing html for #{@hsreplay_id}"
    return true if html_exists?
    save_html!
  end

  def save_html!
    html = open("https://hsreplay.net/replay/#{@hsreplay_id}").read
    ActiveRecord::Base.logger.silence do
      if html_exists?
        replay_html_data = ReplayHtmlData.find_by(hsreplay_id: @hsreplay_id)
        replay_html_data.data = html
        replay_html_data.save!
      else
        ReplayHtmlData.create!({
          hsreplay_id: @hsreplay_id,
          data: html
        })
      end
    end
  end

  def xml_exists?
    ReplayXmlData.exists?(hsreplay_id: @hsreplay_id)
  end

  def save_xml
    logger.info "Importing xml for #{@hsreplay_id}"
    return true if xml_exists?
    save_xml!
  end

  def save_xml!
    replay_html_data = ReplayHtmlData.find_by(hsreplay_id: @hsreplay_id)
    xml_link = replay_html_data.replay_xml_link
    xml = open(xml_link).read.force_encoding("utf-8")
    ActiveRecord::Base.logger.silence do
      if xml_exists?
        replay_xml_data = ReplayXmlData.find_by(hsreplay_id: @hsreplay_id)
        replay_xml_data.data = xml
        replay_xml_data.save!
      else
        ReplayXmlData.create!({
          hsreplay_id: @hsreplay_id,
          data: xml
        })
      end
    end
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/replay_data_importer.log")
  end
end
