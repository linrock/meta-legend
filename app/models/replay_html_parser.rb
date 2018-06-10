class ReplayHtmlParser

  def initialize(html)
    @html = html
  end

  def num_turns
    # old format
    turns_el = doc.css("#infobox-game li").select {|e| e.text =~ /turns/i }[0]
    if turns_el.present?
      n = turns_el.text[/(\d+)/, 1].to_i
      return n if n.present?
    end
    # new format
    json_data["own_turns"]
  end

  def player_names
    return unless json_data.present?
    [ json_data["player_name"], json_data["opponent_name"] ]
  end

  def pilot_name
    json_data["player_name"]
  end

  def replay_xml_link
    link = doc.css("[data-replayurl]").first.attr "data-replayurl"
    link.gsub(/&amp;/, '&')
  end

  def json_data
    return @json_data if defined? @json_data
    @json_data = json_data!
  end
  
  def json_data!
    react_data = doc.css("#react_context")
    react_data.present? ? JSON.parse(react_data.text) : {}
  end

  def doc
    @doc ||= Nokogiri::HTML.parse @html
  end
end
