class SearchController < ActionController::API

  def index
    hsreplay_ids = CombinedReplayData.search do
      # with :p1_class, "Warlock"
      # with :p1_archetype, "Cube"
      case params[:game_type]
      when "standard"
        with :game_type, "standard"
      when "wild"
        with :game_type, "wild"
      end
      case params[:rank_range]
      when "top-100"
        with(:p1_legend_rank).between(1..100)
        with(:p2_legend_rank).between(1..100)
      when "top-500"
        with(:p1_legend_rank).between(1..500)
        with(:p2_legend_rank).between(1..500)
      when "top-1000"
        with(:p1_legend_rank).between(1..1_000)
        with(:p2_legend_rank).between(1..1_000)
      else
        all do
          any_of do
            without(:p1_legend_rank, nil)
            with(:p1_rank).between(1..5)
          end
          any_of do
            without(:p2_legend_rank, nil)
            with(:p2_rank).between(1..5)
          end
        end
      end
      order_by(:played_at, :desc)
      paginate(page: 1, per_page: 30)
    end.each_hit_with_result.map {|_, result| result.hsreplay_id }
    render json: {
      replays: replay_data(hsreplay_ids),
      page: 1,
      per_page: 30,
    }
  end

  private

  def replay_data(hsreplay_ids)
    hsreplay_ids.map do |hsreplay_id|
      ReplayDataCache.new.replay_data_hash(hsreplay_id) rescue nil
    end.compact
  end
end
