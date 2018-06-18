class HomeController < ApplicationController

  def index
    @legend_stats = ReplayStatsCache.new.legend_stats(
      params[:rank],
      params[:region]
    )
    @replay_data = JsonResponseCache.new(params).cached_json_response || "{}"
    set_title
    set_meta_description
  end

  private

  def set_title
    @title = "Meta Legend"
    @title = "#{player_type} | #{@title}" if player_type.present?
  end

  def set_meta_description
    player_type_str = player_type.present? ? "#{player_type} players" : "players"
    @meta_desc = "Hearthstone replays and statistics by legend-rank #{player_type_str}. Learn how the best players play the top decks."
  end

  def route_map
    @route_map ||= RouteMap.new
  end

  def player_type
    return @player_type if defined? @player_type
    @player_type = player_type!
  end

  def player_type!
    route = route_map.lookup params[:path]
    return "" unless route.present?
    if route[:class] and route[:archetype]
      "#{route[:archetype]} #{route[:class]}"
    elsif route[:class]
      route[:class]
    else
      ""
    end
  end
end
