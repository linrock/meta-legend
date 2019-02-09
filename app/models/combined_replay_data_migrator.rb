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
    ActiveRecord::Base.logger.silence do
      hsreplay_ids.each do |hsreplay_id|
        self.new(hsreplay_id).migrate!
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
    begin
      extract_replay_outcome_data
      extract_xml_data
      extract_game_api_data
    rescue => e
      puts "Error migrating: #{@hsreplay_id}"
      puts "#{e.class.name}: #{e.message}"
      puts "#{e.backtrace.join("\n")}"
    end
  end

  def extract_replay_outcome_data
    @combined.p1_class = ro.player1_class
    @combined.p1_archetype = ro.player1_archetype_prefix
    @combined.p1_rank = ro.player1_rank
    @combined.p1_legend_rank = ro.player1_legend_rank
    @combined.p2_class = ro.player2_class
    @combined.p2_archetype = ro.player2_archetype_prefix
    @combined.p2_rank = ro.player2_rank
    @combined.p2_legend_rank = ro.player2_legend_rank
    @combined.found_at = ro.created_at
    @combined.save!
  end

  def extract_xml_data
    @combined.p1_battletag = rx.extracted_data["p1"]["tag"]
    @combined.p2_battletag = rx.extracted_data["p2"]["tag"]
    @combined.utc_offset = rx.utc_offset
    @combined.save!
  end

  def extract_game_api_data
    @combined.p1_deck_card_ids = rg.friendly_deck["cards"].sort
    @combined.p2_deck_card_ids = rg.opposing_deck["cards"].sort
    @combined.p2_predicted_deck_card_ids = (rg.opposing_deck["predicted_cards"] || []).sort
    @combined.p1_wins = rg.data["won"]
    @combined.game_type = rg.game_type
    @combined.ladder_season = rg.ladder_season
    @combined.played_at = rg.played_at
    @combined.duration_seconds = rg.duration_seconds
    @combined.num_turns = rg.num_turns
    @combined.metadata = rg.metadata if rg.metadata.present?
    @combined.save!
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
