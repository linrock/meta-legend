class HomeController < ApplicationController

  def index
    @legend_stats = ReplayStatsCache.new.legend_stats(
      params[:rank],
      params[:region]
    )
    @replay_data = JsonResponseCache.new(params).cached_json_response || "{}"
    title_and_description = TitleAndDescription.new(params)
    @title = title_and_description.html_title
    @meta_desc = title_and_description.html_meta_description
  end

  def beta
    hsreplay_ids = CombinedReplayData.search do
      with :p1_class, "Hunter"
      with :p1_archetype, "Midrange"
    end.each_hit_with_result.map {|_, result| result.hsreplay_id }
    @replay_data = replay_data(hsreplay_ids)
    @stats_popular_decks = StatsPopularDecks.new
    @stats_top_submitters = StatsTopSubmitters.new
    render layout: "beta"
  end

  private

  def replay_data(hsreplay_ids)
    hsreplay_ids.map do |hsreplay_id|
      ReplayDataCache.new.replay_data_hash(hsreplay_id) rescue nil
    end.compact.to_json
  end
end
