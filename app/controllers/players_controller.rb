class PlayersController < ApplicationController

  def show
    @player_name = params[:name]
    # @hsreplay_ids = hsreplay_ids_from_xml_data
    # @hsreplay_ids = hsreplay_ids_from_solr
    # if @hsreplay_ids.length == 0
    #   render status: 404
    #   return
    # end
    @title = "#{@player_name} | Players | Meta Legend"
    @meta_desc = "Find recent legend replays where #{@player_name} played a game"
    # @replay_data = @hsreplay_ids.map do |hsreplay_id|
    #   ReplayDataCache.new.replay_data_hash(hsreplay_id) rescue nil
    # end.compact.sort_by {|r| -r[:found_at].to_i }.to_json
    if replay_data_search.count == 0
      render status: 404, file: "public/404.html", layout: false
    else
      @replay_data = replay_data_search.to_json
      render layout: "beta"
    end
  end

  private

  def hsreplay_ids_from_xml_data
    ReplayXmlData
      .has_player_name(params[:name])
      .order("played_at DESC")
      .limit(80)
      .pluck(:hsreplay_id)
  end

  def hsreplay_ids_from_solr
    CombinedReplayDataQuery
      .new({ name: params[:name] })
      .search_results
      .results.pluck(:hsreplay_id)
  end

  def replay_data_search
    @replay_data_search ||= CombinedReplayDataQuery
      .new({ player_name: @player_name })
      .search_results
      .results
  end
end
