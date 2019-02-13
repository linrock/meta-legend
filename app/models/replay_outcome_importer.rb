require 'open-uri'

class ReplayOutcomeImporter
  API_ENDPOINT = "https://hsreplay.net/api/v1/live/replay_feed/"

  def keep_fetching
    n_consecutive_errors = 0
    loop do
      begin
        fetch!
      rescue => e
        logger.error "Error while fetching replays"
        puts "#{e.class.name}: #{e.message}"
        puts e.backtrace
        n_consecutive_errors += 1
        if n_consecutive_errors > 6
          puts "Too many failures in a row. Exiting..."
          exit 1
        end
        sleep 60 * 2 ** n_consecutive_errors
      else
        n_consecutive_errors = 0
        sleep 180
      end
    end
  end

  def fetch!
    json_string = open(API_ENDPOINT).read
    import_from_json_api_response json_string
  end

  def import_from_json_api_response(json_string)
    num_saved = 0
    legend_saved = 0
    rank5_saved = 0
    data = JSON.parse json_string
    replay_outcomes = data["data"]
    hsreplay_id_map = replay_outcomes.group_by {|ro| ro["id"] }
    hsreplay_ids = Set.new(hsreplay_id_map.keys)
    existing_hsreplay_ids = Set.new(
      ReplayOutcome.where(hsreplay_id: hsreplay_ids).pluck(:hsreplay_id)
    )
    ReplayOutcome.transaction do
      (hsreplay_ids - existing_hsreplay_ids).to_a.each do |hsreplay_id|
        replay_data = hsreplay_id_map[hsreplay_id][0]
        replay_outcome = ReplayOutcome.new(
          hsreplay_id: hsreplay_id,
          data: replay_data
        )
        if replay_outcome.valid?
          begin
            replay_outcome.save!
          rescue
            logger.error "#{hsreplay_id} is invalid #{replay_data.to_json}"
          end
          if replay_outcome.legend_game?
            legend_saved += 1
          elsif replay_outcome.rank_5_and_higher_game?
            rank5_saved += 1
          end
          num_saved += 1
        else
          logger.error "#{hsreplay_id} is invalid #{replay_data.to_json}"
        end
      end
    end
    logger.info "Saved #{num_saved}/#{replay_outcomes.length} replays (#{legend_saved} legend, #{rank5_saved} rank 5+)"
    true
  end

  private

  def logger
    STDOUT.sync = true
    @logger ||= Logger.new(STDOUT)
  end
end
