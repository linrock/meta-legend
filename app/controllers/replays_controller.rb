class ReplaysController < ActionController::API

  def index
    if RouteMap.new.exists? params[:path]
      render json: JsonResponseCache.new(params).json_response
    else
      render json: "{}", status: 404
    end
  end

  def popular
    rank_filter = ReplayOutcomeFilter.get_rank_filter(params[:rank])
    region_filter = ReplayOutcomeFilter.get_region_filter(params[:region])
    replay_stats = ReplayStatsCache.new.legend_stats(rank_filter, region_filter)
    render json: {
      replay_stats: replay_stats
    }
  end
end
