class ReplayHtmlData

  def initialize(replay_html)
    @replay_html = replay_html
  end

  def num_turns
    turns_el = doc.css("#infobox-game li").select {|e| e.text =~ /turns/i }.first
    return unless turns_el.present?
    turns_el.text[/(\d+)/, 1].to_i
  end

  def doc
    @doc ||= Nokogiri::HTML.parse @replay_html
  end
end
