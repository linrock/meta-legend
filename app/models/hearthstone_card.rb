class HearthstoneCard
  DATA_FILE = "data/cards.json"

  def self.card_map
    return @@card_map if defined? @@card_map
    json_data = open(DATA_FILE, 'r').read
    @@card_map ||= Hash[JSON.parse(json_data).map {|card|
      [card['id'], {
        cost: card['cost'],
        name: card['name'],
      }]
    }]
  end

  def self.lookup(card_id)
    card_map[card_id]
  end

  def self.card_ids_to_cards(card_ids)
    card_ids.map {|id| lookup(id) }
  end

  def self.card_ids_to_deck_list(card_ids)
    card_ids_to_cards(card_ids)
      .group_by {|card| card[:name] }.values
      .map {|cards| cards[0].merge({ n: cards.length }) }
      .sort_by {|card| [card[:cost], card[:name]] }
  end
end
