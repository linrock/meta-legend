class ReplayXmlData < ApplicationRecord
  validates_uniqueness_of :hsreplay_id
  validates_presence_of :hsreplay_id
  validates_presence_of :data, unless: :data_extracted?
  validate :ensure_data_is_hsreplay, unless: :data_extracted?
  validate :check_required_xpaths, unless: :data_extracted?
  validate :has_either_data_or_extracted_data

  after_validation :log_if_invalid
  after_create :extract_and_save_xml_data
  after_create :set_played_at_and_utc_offset
  after_create :set_utc_offset

  private *delegate(
    :doc, :player_legend_ranks,
    :players, :player_names,
    :pilot_name, :deck_card_ids,
    :winner_name, :loser_name,
    :winner_entity_id, :loser_entity_id,
    :pilot_pre_mulligan_hand,
    :pilot_post_mulligan_hand,
    to: :replay_xml_parser
  )

  scope :since, -> (timestamp) do
    where("created_at > ?", timestamp)
  end

  scope :has_card_id, -> (card_id) do
    where("(extracted_data ->> 'deck_card_ids')::jsonb ? '#{card_id}'")
  end

  scope :has_player_name, -> (player_name) do
    where("extracted_data #>> '{p1,tag}' ILIKE ?", "#{player_name}#%").or(
      where("extracted_data #>> '{p2,tag}' ILIKE ?", "#{player_name}#%")
    )
  end

  def game_played_at
    @game_played_at ||= replay_xml_parser.played_at
  end

  def to_hash
    extracted_data&.deep_symbolize_keys || to_hash!
  end

  def to_hash!
    players = doc.xpath("//Player").map do |player|
      {
        tag: player.attr("name"),
        rank: player.attr("rank"),
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
    data = {
      played_at: game_played_at,
      p1: players[0],
      p2: players[1],
      pilot_name: pilot_name,
      deck_card_ids: deck_card_ids,
    }
    begin
      data[:p1][:pre_mulligan_card_ids] = pilot_pre_mulligan_hand
      data[:p1][:post_mulligan_card_ids] = pilot_post_mulligan_hand
    rescue
      logger.error "#{hsreplay_id} - failed to extract pre/post mulligan card ids"
    end
    if winner_name.nil?
      # deal with draws
      data[:winner] = nil
    elsif players[0][:tag] == winner_name
      data[:winner] = 'p1'
    else
      data[:winner] = 'p2'
    end
    data
  end

  def extract_and_save_xml_data
    self.extracted_data = to_hash!
    self.save!
  end

  def set_played_at_and_utc_offset
    self.played_at = game_played_at
    self.save! if self.played_at.present?
    self.set_utc_offset
  end

  def set_utc_offset
    self.utc_offset = game_played_at.to_datetime.utc_offset / 3600
    self.save!
  end

  def replay_xml_parser
    @replay_xml_parser ||= ReplayXmlParser.new(data)
  end

  private

  def data_extracted?
    extracted_data.present?
  end

  def hsreplay_xml?
    replay_xml_parser.hsreplay_xml? rescue false
  end

  def ensure_data_is_hsreplay
    hsreplay_xml?
  end

  def has_either_data_or_extracted_data
    unless data.present? or data_extracted?
      errors.add(:data, "can't be empty if extracted_data does not exist")
    end
  end

  def check_required_xpaths
    return unless hsreplay_xml?
    n_cards = deck_card_ids.length
    if n_cards != 30
      errors.add(:data, "has wrong # of cards - #{n_cards}")
    end
    if pilot_name.nil?
      errors.add(:data, "is missing pilot_name")
    end
  end

  def log_if_invalid
    if errors.present?
      logger.info "#{hsreplay_id} is invalid - #{errors.messages.to_s}"
    end
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/replay_xml_data.log")
  end
end
