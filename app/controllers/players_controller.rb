class PlayersController < ApplicationController

  def show
    @player_name = params[:name]
    @hsreplay_ids = ReplayXmlData
      .has_player_name(params[:name])
      .order("played_at DESC")
      .limit(80)
      .pluck(:hsreplay_id)
    if @hsreplay_ids.length == 0
      render status: 404
      return
    end
    @title = "#{@player_name} | Players | Meta Legend"
    @meta_desc = "Find recent legend replays where #{@player_name} played a game"
    @replay_data = @hsreplay_ids.map do |hsreplay_id|
      ReplayDataCache.new.replay_data_hash hsreplay_id
    end.compact.sort_by {|r| -r[:found_at].to_i }.to_json
  end
end
