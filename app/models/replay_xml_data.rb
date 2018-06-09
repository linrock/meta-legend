class ReplayXmlData < ApplicationRecord
  validates_uniqueness_of :hsreplay_id
  validate :has_either_data_or_extracted_data
  validate :check_required_xpaths

  after_create :extract_and_save_xml_data

  delegate :doc, :players, :player_names,
           :player_legend_ranks, :winner_name,
           :loser_name, :pilot_name, :deck_card_ids,
           :winner_entity_id, :loser_entity_id,
           to: :replay_xml_parser

  scope :since, -> (timestamp) do
    where("created_at > ?", timestamp)
  end

  def to_hash
    extracted_data&.deep_symbolize_keys || to_hash!
  end

  def to_hash!
    players = doc.xpath("//Player").map do |player|
      {
        tag: player.attr("name"),
        legend_rank: player.attr("legendRank"),
      }
    end
    players.each do |player|
      unless player[:legend_rank].present?
        logger.info "#{hsreplay_id} - player #{player[:tag]} missing legend rank"
      end
    end
    players.reverse! if players[1][:tag] == pilot_name
    # p1 is always the pilot
    {
      p1: players[0],
      p2: players[1],
      winner: players[0][:tag] == winner_name ? 'p1' : 'p2',
      pilot_name: pilot_name,
      deck_card_ids: deck_card_ids,
    }
  end

  def extract_and_save_xml_data
    self.extracted_data = to_hash!
    self.save!
  end

  def replay_xml_parser
    @replay_xml_parser ||= ReplayXmlParser.new(data)
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

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/replay_xml_data.log")
  end
end
