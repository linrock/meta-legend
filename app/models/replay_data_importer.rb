require 'open-uri'

class ReplayDataImporter

  def self.import_missing_data!
    ReplayOutcome.legend_players.since(3.days.ago).find_each do |r|
      importer = self.new(r.hsreplay_id)
      next if importer.data_exists?
      importer.save_html
      importer.save_xml
    end
  end

  def initialize(hsreplay_id)
    @hsreplay_id = hsreplay_id
  end

  def data_exists?
    html_exists? and xml_exists?
  end

  def html_exists?
    ReplayHtmlData.exists?(hsreplay_id: @hsreplay_id)
  end

  def save_html
    return true if html_exists?
    save_html!
  end

  def save_html!
    html = open("https://hsreplay.net/replay/#{@hsreplay_id}").read
    ReplayHtmlData.create!({
      hsreplay_id: @hsreplay_id,
      data: html
    })
  end

  def xml_exists?
    ReplayXmlData.exists?(hsreplay_id: @hsreplay_id)
  end

  def save_xml
    return true if xml_exists?
    save_xml!
  end

  def save_xml!
    replay_html_data = ReplayHtmlData.find_by(hsreplay_id: @hsreplay_id)
    xml_link = replay_html_data.replay_xml_link
    xml = open(xml_link).read.force_encoding("utf-8")
    ReplayXmlData.create!({
      hsreplay_id: @hsreplay_id,
      data: xml
    })
  end
end
