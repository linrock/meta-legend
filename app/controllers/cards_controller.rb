class CardsController < ApplicationController

  def index
  end

  def show
    @card = HearthstoneCard.card_path_map[params[:card].strip]
    unless @card.present?
      render status: 404
      return
    end
    @title = "#{@card[:name]} | Meta Legend"
    @meta_desc = "Find recent legend replays where #{@card[:name]} was used in a game"
    @hsreplay_ids = ReplayXmlData
      .has_card_id(@card[:id])
      .order("created_at DESC")
      .limit(100)
      .pluck(:hsreplay_id)
    @replay_data = @hsreplay_ids.map do |hsreplay_id|
      ReplayJson.new(hsreplay_id).to_hash
    end.to_json
  end
end
