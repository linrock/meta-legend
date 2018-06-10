class ReplaysController < ActionController::Base

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
end
