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
    # hsreplay_ids = CombinedReplayData.search do
    #   with :p1_class, "Hunter"
    #   with :p1_archetype, "Midrange"
    #   order_by :played_at, :desc
    # end.each_hit_with_result.map {|_, result| result.hsreplay_id }
    # @replay_data = replay_data(hsreplay_ids)
    @replay_data = CombinedReplayData.search do
      all do
        any_of do
          without(:p1_legend_rank, nil)
          with(:p1_rank).between(1..5)
        end
        any_of do
          without(:p2_legend_rank, nil)
          with(:p2_rank).between(1..5)
        end
        with(:num_turns).greater_than(7)
      end
      order_by :played_at, :desc
    end.results.to_json
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
