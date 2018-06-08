class ReplayXmlData < ApplicationRecord
  validates_uniqueness_of :hsreplay_id
  validate :has_either_data_or_extracted_data
  validate :check_required_xpaths

  before_save :extract_and_save_xml_data

  def to_hash
    players = doc.xpath("//Player").map do |player|
      {
        tag: player.attr("name"),
        legend_rank: player.attr("legendRank"),
      }
    end
    players.reverse! if players[1][:tag] == pilot_name
    # p1 is always the pilot
    {
      p1: players[0],
      p2: players[1],
      winner: players[0][:tag] == winner_name ? 'p1' : 'p2',
    }
  end

  def player_names
    doc.xpath("//Player/@name").map(&:value)
  end

  # since the legend rank for a player in the replay is sometimes nil
  def player_legend_ranks
    doc.xpath("//Player").map {|p| p.attr("legendRank") }
  end

  def winner_name
    doc.xpath("//Player[@id=#{winner_entity_id}]").attr("name").value
  end

  def loser_name
    doc.xpath("//Player[@id=#{loser_entity_id}]").attr("name").value
  end

  def pilot_name
    doc.xpath("//Deck/parent::Player").attr("name").value rescue nil
  end

  def deck_card_ids
    doc.xpath("//Deck/Card/@id").map(&:value)
  end

  def winner_entity_id
    doc.xpath("//TagChange[@tag=17][@value=4]").attr("entity").value
  end

  def loser_entity_id
    doc.xpath("//TagChange[@tag=17][@value=5]").attr("entity").value
  end

  def extract_and_save_xml_data
    self.extracted_data = to_hash
  end

  def doc
    @doc ||= Nokogiri.parse data
  end

  private

  def has_either_data_or_extracted_data
    unless data.present? or extracted_data.present?
      errors.add(:data, "can't be empty if extracted_data does not exist")
    end
  end

  def check_required_xpaths
    n_cards = deck_card_ids.length
    if n_cards != 30
      errors.add(:data, "has wrong # of cards - #{n_cards}")
    end
    if pilot_name.nil?
      errors.add(:data, "is missing pilot_name")
    end
  end
end
