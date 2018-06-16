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
    replay_stats = ReplayStatsCache.new.legend_stats(filter)
    render json: {
      replay_stats: replay_stats
    }
  end
end
