class HsreplayCardImporter

  def self.import_all!
    self.hsreplay_card_ids.each do |hsreplay_card_id|
      self.new(hsreplay_card_id).import_html!
    end
  end

  # the cards that are used in any given archetype
  def self.hsreplay_card_ids
    components = Archetype.pluck("
      data #> '{standard_ccp_signature_core, components}'
    ")
    components.flatten.uniq
  end

  def initialize(hsreplay_card_id)
    @hsreplay_card_id = hsreplay_card_id
  end

  def import_html!
    begin
      fetched_html = html
      open("data/hsreplay-cards/#{@hsreplay_card_id}.html", "w") do |f|
        f.write fetched_html
      end
    rescue => e
      puts "#{e.class.name}: #{e.message}"
      puts "#{e.backtrace.join("\n")}"
    end
  end

  def html
    @html ||= open("https://hsreplay.net/cards/#{@hsreplay_card_id}/").read
  end
end
