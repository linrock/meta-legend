class ReplaysController < ActionController::API

  def index
    if RouteMap.new.exists? params[:path]
      render json: JsonResponseCache.new(params).json_response
    else
      render json: "{}", status: 404
    end
  end

  def show
    hsreplay_id = params[:id]
    replay_data = ReplayData.new(hsreplay_id)
    if replay_data.exists?
      render json: {
        hsreplay_id: hsreplay_id,
        player_names: replay_data.player_names,
        has_both_decks: replay_data.has_both_decks?,
        num_turns: replay_data.num_turns,
      }
    else
      render json: "{}", status: 404
    end
  end
end
