require 'open-uri'

class HearthstoneCardImporter
  API_ENDPOINT = "https://api.hearthstonejson.com/v1/latest/enUS/cards.collectible.json"

  def self.import!
    json_data = open(API_ENDPOINT, 'r').read
    open(HearthstoneCard::DATA_FILE, 'w') do |f|
      f.write json_data.force_encoding('utf-8')
    end
  end
end
