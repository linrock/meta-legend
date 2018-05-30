require 'open-uri'

class ReplayExtractor

  def initialize(hsreplay_id)
    @hsreplay_id = hsreplay_id
  end

  def replay_xml_link
    doc.css("a[download]").first.attr "href"
  end

  def replay_xml
    open(replay_xml_link).read
  end

  private

  def doc
    @doc ||= open("https://hsreplay.net/replay/#{@hsreplay_id}").read
  end
end
