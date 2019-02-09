# Creates or updates replay data for an hsreplay id from:
# ReplayOutcome
# ReplayHtmlData
# ReplayXmlData
# ReplayGameApiResponse

class CombinedReplayDataMigrator

  def initialize(hsreplay_id)
    @hsreplay_id = hsreplay_id
    @combined = CombinedReplayData.find_or_initialize_by(
      hsreplay_id: hsreplay_id
    )
  end

  def check_data
    {
      replay_outcome: ro.present?,
      replay_html: rh.present?,
      replay_xml: rx.present?,
      replay_game_api_response: rg.present?
    }
  end

  def migrate!
    extract_replay_outcome_data
    extract_html_data
    extract_xml_data
    extract_game_api_data
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

  def extract_html_data
    # rh = ReplayHtmlData.find_by(hsreplay_id: @hsreplay_id)
    # @combined.save!
  end

  def extract_xml_data
    @combined.p1_battletag = rx.extracted_data["p1"]["tag"]
    @combined.p2_battletag = rx.extracted_data["p2"]["tag"]
    @combined.p1_wins = rx.extracted_data["winner"] == "p1"
    @combined.utc_offset = rx.utc_offset
    @combined.save!
  end

  def extract_game_api_data
    @combined.p1_deck_card_ids = rg.friendly_deck
    @combined.p2_deck_card_ids = rg.opposing_deck["cards"]
    @combined.p2_predicted_deck_card_ids = rg.opposing_deck["predicted_cards"]
    @combined.game_type = rg.game_type
    @combined.ladder_season = rg.ladder_season
    @combined.played_at = rg.played_at
    @combined.duration_seconds = rg.duration_seconds
    @combined.num_turns = rg.num_turns
    @combined.save!
  end

  private

  def ro
    @ro ||= ReplayOutcome.find_by(hsreplay_id: @hsreplay_id)
  end

  def rh
    @rh ||= ReplayHtmlData.find_by(hsreplay_id: @hsreplay_id)
  end

  def rx
    @rx ||= ReplayXmlData.find_by(hsreplay_id: @hsreplay_id)
  end

  def rg
    @rg ||= ReplayGameApiResponse.find_by(hsreplay_id: @hsreplay_id)
  end
end
