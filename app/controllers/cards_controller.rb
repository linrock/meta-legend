class CardsController < ApplicationController

  def index
  end

  def show
    @card = HearthstoneCard.card_path_map[params[:card].strip]
    unless @card.present?
      render status: 404
      return
    end
    @hsreplay_ids = ReplayXmlData
      .has_card_id(@card[:id])
      .order("created_at DESC")
      .limit(100)
      .pluck(:hsreplay_id)
  end
end
