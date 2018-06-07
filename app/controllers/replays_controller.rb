class ReplaysController < ActionController::API

  def index
    if RouteMap.new.exists? params[:path]
      render json: JsonResponseCache.new(params).json_response
    else
      render json: "{}", status: 404
    end
  end

  def popular
    filter = ReplayOutcomeFilter.get_filter(params[:filter])
    replay_outcomes = ReplayOutcome.legend_players.since(2.days.ago).filter(filter)
    replay_stats = ReplayStats.new(replay_outcomes)
    render json: {
      filter: filter,
      frequencies: replay_stats.archetype_counts,
      n: replay_stats.replays_count,
      since: replay_stats.oldest_replay_timestamp
    }
  end

  def show
    hsreplay_id = params[:id]
    replay_data = ReplayData.new(hsreplay_id)
    if replay_data.exists?
      render json: {
        hsreplay_id: hsreplay_id,
        player_names: replay_data.replay_xml_data.player_names,
        pilot_name: replay_data.replay_xml_data.pilot_name,
        winner_name: replay_data.replay_xml_data.winner_name,
        num_turns: replay_data.num_turns,
        hash: replay_data.to_hash,
      }
    else
      render json: "{}", status: 404
    end
  end
end
