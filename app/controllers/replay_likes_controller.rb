class ReplayLikesController < ApplicationController

  # user likes a replay
  def create
    if @user
      hsreplay_id = params[:replay_id]
      if ReplayOutcome.exists?(hsreplay_id: hsreplay_id)
        @user.liked_replays.find_or_create_by!({ hsreplay_id: hsreplay_id })
        like_count = LikedReplay.where(hsreplay_id: hsreplay_id).count
        render json: {
          hsreplay_id: hsreplay_id,
          likes: like_count,
          liked: true,
        }
      else
        render json: { hsreplay_id: hsreplay_id, error: "Replay not found" }, status: 404
      end
    else
      render json: { error: "Not logged in" }, status: 401
    end
  end

  def likes_batch
    hsreplay_ids = params[:hsreplay_ids]
    if hsreplay_ids.length > ReplayOutcomeQuery::PAGE_SIZE * 2
      render json: { error: "Request size too large" }, status: 500
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
end
