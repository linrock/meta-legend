require 'open-uri'

class ArchetypeImporter
  API_ENDPOINT = "https://hsreplay.net/api/v1/archetypes/"
  DATA_FILE = Rails.root.join("data/archetypes.json")

  def check!
    hsreplay_archetypes.each do |hsrp_archetype|
      archetype = Archetype.find_by_archetype_id(hsrp_archetype["id"])
      begin
        if !archetype
          puts "Archetype doesn't exist: #{hsrp_archetype["id"]}"
        elsif archetype.data.dig("standard_ccp_signature_core", "as_of") !=
              hsrp_archetype.dig("standard_ccp_signature_core", "as_of")
          puts "Archetype was updated: #{archetype.data["id"]}"
          puts archetype.data.dig("standard_ccp_signature_core", "as_of")
          puts hsrp_archetype.dig("standard_ccp_signature_core", "as_of")
        end
      rescue 
        binding.pry
      end
    end
  end

  def import!(filter = false)
    data = json_data
    if filter # filter out archetypes that fail validations
      data.select! do |d|
        Archetype.new(data: d).valid? && \
        d["standard_ccp_signature_core"].present?
      end
    end
    data = JSON.pretty_generate(data).to_s
    open(DATA_FILE, 'w') do |f|
      f.write data
    end
  end

  def fetch
    open(API_ENDPOINT).read
  end

  def json_data
    JSON.parse(fetch).sort_by {|arch| arch["id"] }
  end

  def hsreplay_archetypes
    return @hsreplay_archetypes if defined? @hsreplay_archetypes
    @hsreplay_archetypes = json_data
  end
end
