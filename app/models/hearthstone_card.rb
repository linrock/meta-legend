# hearthstone card data from hearthstonejson.com api

module HearthstoneCard
  DATA_FILE = "data/cards.json"

  # list of cards
  def card_json_data
    @@card_json_data ||= open(DATA_FILE, 'r') { |f| JSON.parse(f.read) }
  end

  # map id (ie. TRL_569) -> shortened card info
  def card_map
    return @@card_map if defined? @@card_map
    @@card_map ||= Hash[card_json_data.map {|card|
      [card['id'], card_data(card)]
    }]
  end

  # map id (ie. TRL_569) -> full card info
  def full_card_map
    return @@full_card_map if defined? @@full_card_map
    @@full_card_map ||= Hash[card_json_data.map {|card|
      [card['id'], card]
    }]
  end

  # map http path -> card info
  def card_path_map
    return @@card_path_map if defined? @@card_path_map
    @@card_path_map ||= Hash[card_json_data.map {|card|
      [card_name_to_path(card['name']), card_data(card)]
    }]
  end

  # handles cards like LOOT_103t1
  def find_by_id(card_id, full_info = false)
    cleaned_card_id = card_id.gsub(/t\d+\z/, '')
    full_info ? full_card_map[cleaned_card_id] : card_map[cleaned_card_id]
  end

  def find_by_name(card_name)
    card_json_data.find {|c| c["name"] == card_name }
  end

  def card_name_to_path(card_name)
    card_name.gsub(/('|!|,|\.|:)/, '').gsub(/\s+/, '-').downcase
      .gsub(/[^0-9a-z\-]/, '')
  end

  def card_data(card)
    {
      id: card['id'],
      cost: card['cost'],
      name: card['name'],
      rarity: card['rarity']&.downcase,
    }
  end

  def card_ids_to_cards(card_ids)
    card_ids.map { |card_id| find_by_id(card_id) }
  end

  def card_ids_to_deck_list(card_ids)
    card_ids_to_cards(card_ids)
      .group_by {|card| card[:name] }.values
      .map {|cards| cards[0].merge({ n: cards.length }) }
      .sort_by {|card| [card[:cost], card[:name]] }
  end

  extend self
end
