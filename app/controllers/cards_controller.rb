class CardsController < ApplicationController

  def index
  end

  def show
    @card = HearthstoneCard.card_path_map[params[:card].strip]
    @hsreplay_card_id = ArchetypeCardMap.new.hsreplay_card_id @card[:id]
    unless @card.present?
      render status: 404
      return
    end
    @title = "#{@card[:name]} | Cards | Meta Legend"
    @meta_desc = "Find recent legend replays where #{@card[:name]} was used in a game"
    # @hsreplay_ids = hsreplay_ids_from_xml_data
    # @hsreplay_ids = hsreplay_ids_from_solr
    @replay_data = replay_data
    render layout: "beta"
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

  def replay_data
    CombinedReplayDataQuery
      .new({ card_id: @card[:id] })
      .search_results
      .results.to_json
  end
end
