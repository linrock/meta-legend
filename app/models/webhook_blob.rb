# Replay data sent by hsreplay.net

class WebhookBlob < ApplicationRecord
  STATES = %w( converted fetched invalid ignored )
  # nil       - new and not-yet processed
  # invalid   - an invalid webhook blob
  # converted - converted to a replay outcome or enqueued data job
  # ignored   - looked at the contents and did nothing

  validates :state, inclusion: STATES, allow_nil: true

  delegate :hsreplay_id,
           :game_type,
           :friendly_deck_card_ids,
           :opposing_deck_predicted_card_ids,
           :opposing_deck_card_ids,
           :p1_name, :p1_class_name, :p1_rank, :p1_legend_rank,
           :p2_name, :p2_class_name, :p2_rank, :p2_legend_rank,
           :num_turns, :winner, :valid_blob?,
           :to_replay_data,
           to: :webhook_blob_parser

  after_create :enqueue_webhook_blob_converter_job

  # TODO centralize this
  GAME_TYPES = {
    standard: 2,
    arena: 3,
    wild: 30,
  }

  def self.unconverted
    where(converted_at: nil)
  end

  def self.arena
    all.select(&:is_arena?)
  end

  def self.wild
    all.select(&:is_wild?)
  end

  def is_standard?
    game_type == GAME_TYPES[:standard]
  end

  def is_wild?
    game_type == GAME_TYPES[:wild]
  end

  def is_arena?
    game_type == GAME_TYPES[:arena]
  end

  # Called by WebhookConverterJob
  # - creates replay outcomes from valid standard and wild games
  # - fetches data for valid standard, wild, and arena games
  def convert!
    if converted_at.present?
      logger.info "webhook #{id} already has converted_at. Not processing"
      return
    elsif !valid_blob?
      logger.error "webhook #{id} has invalid data. Not processing"
      self.converted_at = Time.now
      self.state = "invalid"
      self.save!
      return
    end
    logger.info "#{p1_name} submitted webhook #{id}. Processing..."
    if !is_standard? or !is_wild? or !is_arena?
      logger.info "Ignoring webhook #{id}. Not standard, wild, or arena"
      self.converted_at = Time.now
      self.state = "ignored"
      self.save!
      return
    end
    create_replay_outcome
    if is_arena? or is_wild?
      # TODO centralize replay data fetching for different game types
      FetchReplayDataJob.new.perform(blob.hsreplay_id)
      if ReplayData.new(blob.hsreplay_id).exists?
        self.converted_at = Time.now
        self.state = "fetched"
        self.save!
      end
    end
  end

  # Only standard and wild game types have replay outcomes
  def create_replay_outcome
    return unless is_standard? or is_wild?
    data = to_replay_outcome_data
    if ReplayOutcome.exists?(hsreplay_id: data[:id])
      logger.info "webhook #{id} already has replay outcome #{data[:id]}. Exiting"
      self.converted_at = Time.now
      self.state = "converted"
      self.save!
    else
      logger.info "#{data[:id]} - creating replay outcome (webhook #{id})"
      ActiveRecord::Base.transaction do
        # this enqueues a fetch replay data job for legend replays
        # TODO enqueue replay data jobs for rank5 and above
        ReplayOutcome.create!({ hsreplay_id: data[:id], data: data })
        self.converted_at = Time.now
        self.state = "converted"
        self.save!
      end
    end
  end

  # matches the shape of a ReplayOutcome#data field
  def to_replay_outcome_data
    {
      id: hsreplay_id,
      player1_won: winner == 'p1' ? "True" : "False",
      player2_won: winner == 'p2' ? "True" : "False",
      player1_rank: p1_rank ? p1_rank.to_s : "None",
      player2_rank: p2_rank ? p1_rank.to_s : "None",
      player1_archetype: p1_archetype_id,
      player2_archetype: p2_archetype_id,
      player1_legend_rank: p1_legend_rank ? p1_legend_rank.to_s : "None",
      player2_legend_rank: p2_legend_rank ? p2_legend_rank.to_s : "None",
      source: "webhook #{id}",
    }
  end

  def p1_archetype_id
    matches = friendly_archetype_matches
    matches.present? && matches[0][:id]
  end

  def p2_archetype_id
    matches = opposing_archetype_matches
    matches.present? && matches[0][:id]
  end

  def friendly_archetype_matches
    ArchetypeMatcher.new(friendly_deck_card_ids, p1_class_name).top_matches
  end

  def opposing_archetype_matches
    card_ids = (opposing_deck_predicted_card_ids || opposing_deck_card_ids)
    ArchetypeMatcher.new(card_ids, p2_class_name).top_matches
  end

  private

  def enqueue_webhook_blob_converter_job
    WebhookBlobConverterJob.perform_async(id)
  end

  def webhook_blob_parser
    WebhookBlobParser.new(blob)
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/webhook_blob.log")
  end
end
