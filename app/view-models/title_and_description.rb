class TitleAndDescription

  # params - rank, region, path
  def initialize(params)
    @params = params
  end

  def html_title
    prefix = [
      rank_type.capitalize,
      (player_type if player_type.present?),
      "replays",
      (region_string if region_string.present?),
    ].compact.join(" ")
    "#{prefix} | Meta Legend"
  end

  def html_meta_description
    player_type_str = player_type.present? ? "#{player_type} players" : "players"
    [
      "Hearthstone replays of games played by",
      rank_type,
      player_type,
      "players",
      region_string,
      ".",
      "Learn how the best players play the top meta decks."
    ].join(" ").gsub(/\s+\./, '.')
  end

  private

  def region_string
    case @params[:region]
    when "americas" then "in the Americas"
    when "europe" then "in Europe"
    when "asia" then "in Asia"
    else ""
    end
  end

  def rank_type
    case @params[:rank]
    when "top-1000" then "top 1000"
    when "top-100" then "top 100"
    else "legend-rank"
    end
  end

  # Druid, Shudderwock Shaman, etc.
  def player_type
    return @player_type if defined? @player_type
    @player_type = player_type!
  end

  def player_type!
    route = route_map.lookup @params[:path]
    return "" unless route.present?
    if route[:class] and route[:archetype]
      "#{route[:archetype]} #{route[:class]}"
    elsif route[:class]
      route[:class]
    else
      ""
    end
  end

  def route_map
    @route_map ||= RouteMap.new
  end
end
