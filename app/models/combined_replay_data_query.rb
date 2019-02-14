# Takes a user-submitted query and returns results

class CombinedReplayDataQuery
  PAGE_SIZE = 20   # number of results per page
  PAGE_LIMIT = 20  # highest page

  def initialize(query = {})
    @query = sanitize_query(query)
  end

  def search_results
    query = @query
    if @query[:battletag]
      CombinedReplayData.search do
        any_of do
          with :p1_battletag, query[:battletag]
          with :p2_battletag, query[:battletag]
        end
        order_by :played_at, :desc
        paginate page: 1, per_page: 100
      end
    elsif @query[:name]
      # initial data for /players/:name routes
      CombinedReplayData.search do
        any_of do
          with :p1_name, query[:name]
          with :p2_name, query[:name]
        end
        order_by :played_at, :desc
        paginate page: 1, per_page: 100
      end
    elsif @query[:card_id]
      # initial data for /card routes
      CombinedReplayData.search do
        any_of do
          with :p1_deck_card_ids, query[:card_id]
          with :p2_deck_card_ids, query[:card_id]
        end
        order_by :played_at, :desc
        paginate page: 1, per_page: PAGE_SIZE
      end
    else
      CombinedReplayData.search do
        # top 100 legend players
        top_100 = -> {
          with(:p1_legend_rank).between(1..100)
          with(:p2_legend_rank).between(1..100)
        }

        # top 500 legend players
        top_500 = -> {
          with(:pilot_legend_rank).between(1..500)
          with(:opponent_legend_rank).between(1..500)
        }

        # top 1000 legend players
        top_1000 = -> {
          with(:pilot_legend_rank).between(1..1000)
          with(:opponent_legend_rank).between(1..1000)
        }

        # rank 5+ players
        rank_5 = -> {
          all do
            any_of do
              with(:pilot_legend_rank)
              with(:pilot_rank).between(1..5)
            end
            any_of do
              with(:opponent_legend_rank)
              with(:opponent_rank).between(1..5)
            end
          end
        }
      end
    end
  end

  private

  def sanitize_query(query)
    query
  end
end
