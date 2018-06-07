class ReplayHtmlData < ApplicationRecord
  validates_uniqueness_of :hsreplay_id

  def num_turns
    turns_el = doc.css("#infobox-game li").select {|e| e.text =~ /turns/i }.first
    return unless turns_el.present?
    turns_el.text[/(\d+)/, 1].to_i
  end

  def replay_xml_link
    link = doc.css("[data-replayurl]").first.attr "data-replayurl"
    link.gsub(/&amp;/, '&')
  end

  def doc
    @doc ||= Nokogiri::HTML.parse data
  end
end
