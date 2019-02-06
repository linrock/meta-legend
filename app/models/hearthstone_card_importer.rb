require 'open-uri'

class HearthstoneCardImporter
  API_ENDPOINT = "https://api.hearthstonejson.com/v1/latest/enUS/cards.collectible.json"

  def self.import!
    json_data = JSON.parse open(API_ENDPOINT, 'r').read.force_encoding('utf-8')
    json_data = JSON.pretty_generate(json_data).to_s
    open(HearthstoneCard::DATA_FILE, 'w') do |f|
      f.write json_data
    end
  end
end
