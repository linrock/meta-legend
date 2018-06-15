class CardsController < ApplicationController

  def index
  end

  def show
    @card = HearthstoneCard.card_path_map[params[:card].strip]
    unless @card.present?
      render status: 404
      return
    end
  end
end
