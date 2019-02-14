class SearchController < ActionController::API

  # TODO merge with CombinedReplayDataQuery
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
      if params[:player_name]
        any_of do
          with :p1_name, params[:player_name]
          with :p2_name, params[:player_name]
        end
      else
        with(:num_turns).greater_than(7)
      end
      if params[:card_id] && HearthstoneCard.find_by_id(params[:card_id])
        any_of do
          with :p1_deck_card_ids, params[:card_id]
          with :p2_deck_card_ids, params[:card_id]
        end
      end
      order_by(:played_at, :desc)
      paginate(page: page, per_page: CombinedReplayDataQuery::PAGE_SIZE)
    end.results.as_json
    render json: {
      replays: replay_data,
      page: page,
      per_page: CombinedReplayDataQuery::PAGE_SIZE,
    }
  end

  private

  def page
    page_limit = CombinedReplayDataQuery::PAGE_LIMIT
    p = params[:page].to_i
    p = 1 if p < 1
    p = page_limit if p > page_limit
    p
  end
end
