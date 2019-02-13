class CardsController < ApplicationController

  def index
  end

  def show
    @card = HearthstoneCard.card_path_map[params[:card].strip]
    unless @card.present?
      render status: 404
      return
    end
    @title = "#{@card[:name]} | Cards | Meta Legend"
    @meta_desc = "Find recent legend replays where #{@card[:name]} was used in a game"
    # @hsreplay_ids = hsreplay_ids_from_xml_data
    @hsreplay_ids = hsreplay_ids_from_solr
    @replay_data = @hsreplay_ids.map do |hsreplay_id|
      ReplayDataCache.new.replay_data_hash(hsreplay_id) rescue nil
    end.compact.sort_by {|r| -r[:found_at].to_i }.to_json
  end

  private

  def hsreplay_ids_from_xml_data
    ReplayXmlData
      .has_card_id(@card[:id])
      .order("played_at DESC")
      .limit(80)
      .pluck(:hsreplay_id)
  end

  def hsreplay_ids_from_solr
    CombinedReplayDataQuery
      .new({ card_id: @card[:id] })
      .search_results
      .results.pluck(:hsreplay_id)
  end
end
