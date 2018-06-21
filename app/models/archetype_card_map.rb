class ArchetypeCardMap
  CARD_MAP_FILE = "data/archetype_card_map.json"

  def card_map
    if File.exists?(CARD_MAP_FILE)
      open(CARD_MAP_FILE, "r") do |f|
        JSON.parse f.read
      end
    else
      dynamic_card_map
    end
  end

  # map of card UIDs -> hsreplay card id
  def dynamic_card_map
    map = {}
    Dir.glob("data/hsreplay-cards/*.html").each do |file|
      card_data = HsreplayCardHtmlParser.new(open(file, 'r')).card_data
      map[card_data["card_id"]] = card_data["dbf_id"]
    end
    map
  end

  def export!
    open(CARD_MAP_FILE, "w") do |f|
      f.write dynamic_card_map.to_json
    end
  end
end
