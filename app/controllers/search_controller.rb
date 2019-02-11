class SearchController < ActionController::API

  def index
    replay_data = CombinedReplayData.search do
      if PlayerClass::NAMES.include? params[:p1_class]
        with :p1_class, params[:p1_class]
      end
      if PlayerClass::NAMES.include? params[:p2_class]
        with :p2_class, params[:p2_class]
      end
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
      when "legend"
        without(:p1_legend_rank, nil)
        without(:p2_legend_rank, nil)
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
      paginate(page: 1, per_page: 20)
    end.each_hit_with_result.map {|_, result| result }.as_json
    render json: {
      replays: replay_data,
      page: 1,
      per_page: 20,
    }
  end
end
