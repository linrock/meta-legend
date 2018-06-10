class ReplaysController < ApplicationController

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

  # user likes a replay
  def like
    if @user
      hsreplay_id = params[:replay_id]
      if ReplayOutcome.exists?(hsreplay_id: hsreplay_id)
        @user.liked_replays.find_or_create_by!({ hsreplay_id: hsreplay_id })
        like_count = LikedReplay.where(hsreplay_id: hsreplay_id).count
        render json: {
          hsreplay_id: hsreplay_id,
          likes: like_count
        }
      else
        render json: { hsreplay_id: hsreplay_id, error: "Replay not found" }, status: 404
      end
    else
      render json: { error: "Not logged in" }, status: 400
    end
  end

  # get likes for a replay
  def likes
    hsreplay_id = params[:id]
    if !ReplayOutcome.exists?(hsreplay_id: hsreplay_id)
      render json: { hsreplay_id: hsreplay_id, error: "Replay not found" }, status: 404
      return
    end
    response_hash = {
      hsreplay_id: hsreplay_id,
      likes: LikedReplay.where(hsreplay_id: hsreplay_id).count
    }
    if @user
      response_hash[:liked] = @user.liked_replays.exists?(hsreplay_id: hsreplay_id)
    end
    render json: response_hash
  end

  def likes_batch
    hsreplay_ids = params[:hsreplay_ids]
    if hsreplay_ids.length > ReplayOutcomeQuery::PAGE_SIZE
      render status: 500
      return
    end
    like_counts = LikedReplay.where(hsreplay_id: hsreplay_ids).group(:hsreplay_id).count
    liked_replays = Set.new
    if @user
      liked_replays = Set.new(
        @user.liked_replays.where(hsreplay_id: hsreplay_ids).pluck(:hsreplay_id)
      )
    end
    render json: {
      replay_likes: like_counts.map do |hsreplay_id, counts|
        [hsreplay_id, {
          likes: counts,
          liked: liked_replays.include?(hsreplay_id)
        }]
      end
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
