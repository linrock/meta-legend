# Creates or updates replay data for an hsreplay id from:
# ReplayOutcome
# ReplayXmlData
# ReplayGameApiResponse

class CombinedReplayDataMigrator

  def self.check_hsreplay_ids(hsreplay_ids)
    counts = {
      has_all_data: 0,
      missing_replay_outcome: 0,
      missing_replay_xml: 0,
      missing_game_api_response: 0,
    }
    hsreplay_ids.each do |hsreplay_id|
      check = self.new(hsreplay_id).check_data
      if check.values.all?
        counts[:has_all_data] += 1
      else
        if !check[:replay_outcome]
          counts[:missing_replay_outcome] += 1
        end
        if !check[:replay_xml]
          counts[:missing_replay_xml] += 1
        end
        if !check[:replay_game_api_response]
          counts[:missing_replay_game_api_response] += 1
        end
      end
    end
    counts
  end

  def self.migrate_hsreplay_ids!(hsreplay_ids)
    logger = Logger.new("#{Rails.root}/log/combined_replay_data_migrator.error.log")
    ActiveRecord::Base.logger.silence do
      hsreplay_ids.each do |hsreplay_id|
        begin
          self.new(hsreplay_id).migrate!
        rescue => e
          logger.error "Error migrating: #{hsreplay_id}"
          logger.error "#{e.class.name}: #{e.message}"
        end
      end
    end
  end

  def initialize(hsreplay_id)
    @hsreplay_id = hsreplay_id
    @combined = CombinedReplayData.find_or_initialize_by(
      hsreplay_id: hsreplay_id
    )
  end

  def check_data
    {
      replay_outcome: ro.present?,
      replay_xml: rx.present?,
      replay_game_api_response: rg.present?
    }
  end

  def migrate!
    return unless check_data.values.all?
    extract_xml_data
    extract_game_api_data
    extract_replay_outcome_data
    @combined.found_at = [rx, rg, ro].map(&:created_at).min
    @combined.save!
  end

  def extract_xml_data
    data = rx.extracted_data
    @combined.p1_battletag = data["p1"]["tag"]
    @combined.p2_battletag = rx.extracted_data["p2"]["tag"]
    @combined.utc_offset = rx.utc_offset
  end

  def extract_game_api_data
    @combined.p1_deck_card_ids = rg.friendly_deck["cards"].sort
    @combined.p1_rank = rg.friendly_rank
    @combined.p1_legend_rank = rg.friendly_legend_rank
    @combined.p1_is_first = rg.friendly_player_is_first
    @combined.p1_wins = rg.data["won"]

    @combined.p2_deck_card_ids = rg.opposing_deck["cards"].sort
    @combined.p2_rank = rg.opposing_rank
    @combined.p2_legend_rank = rg.opposing_legend_rank
    @combined.p2_predicted_deck_card_ids = (
      rg.opposing_deck["predicted_cards"] || []
    ).sort
    @combined.p2_is_first = rg.opposing_player_is_first
    @combined.p2_wins = rg.opposing_player_wins

    @combined.game_type = rg.game_type
    @combined.ladder_season = rg.ladder_season
    @combined.played_at = rg.played_at
    @combined.duration_seconds = rg.duration_seconds
    @combined.num_turns = rg.num_turns
    @combined.metadata = rg.metadata if rg.metadata.present?
  end

  # make sure that p1 is the pilot
  def extract_replay_outcome_data
    if @combined.p1_rank == ro.player1_rank&.to_i && \
       @combined.p1_legend_rank == ro.player1_legend_rank&.to_i
      @combined.p1_class = ro.player1_class
      @combined.p1_archetype = ro.player1_archetype_prefix
      @combined.p2_class = ro.player2_class
      @combined.p2_archetype = ro.player2_archetype_prefix
    elsif @combined.p1_rank == ro.player2_rank&.to_i && \
          @combined.p1_legend_rank == ro.player2_legend_rank&.to_i
      @combined.p1_class = ro.player2_class
      @combined.p1_archetype = ro.player2_archetype_prefix
      @combined.p2_class = ro.player1_class
      @combined.p2_archetype = ro.player1_archetype_prefix
    else
      # Ranks in the data are mismatched, so invalidate them
      @combined.p1_rank = nil
      @combined.p1_legend_rank = nil
      @combined.p2_rank = nil
      @combined.p2_legend_rank = nil
    end
    if ro.data["source"]
      @combined.metadata[:source] = ro.data["source"]
    end
  end

  private

  def ro
    @ro ||= ReplayOutcome.find_by(hsreplay_id: @hsreplay_id)
  end

  def rx
    @rx ||= ReplayXmlData.find_by(hsreplay_id: @hsreplay_id)
  end

  def rg
    @rg ||= ReplayGameApiResponse.find_by(hsreplay_id: @hsreplay_id)
  end
end
