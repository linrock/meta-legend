class HearthstoneCard
  DATA_FILE = "data/cards.json"

  def self.id_to_name_map
    return @@id_to_name_map if defined? @@id_to_name_map
    json_data = open(DATA_FILE, 'r').read
    @@id_to_name_map ||= Hash[JSON.parse(json_data).map {|card|
      [card['id'], card['name']]
    }]
  end

  def self.name_by_card_id(card_id)
    id_to_name_map[card_id]
  end

  def self.card_ids_to_names(card_ids)
    card_ids.map {|id| name_by_card_id(id) }
  end
end
