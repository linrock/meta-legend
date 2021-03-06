class JsonResponse
  PAGE_LIMIT = 10

  def initialize(options = {})
    @path = options[:path] || "/"
    @rank = ReplayOutcomeFilter.get_rank_filter(options[:rank])
    @region = ReplayOutcomeFilter.get_region_filter(options[:region])
    @page = get_page options[:page].to_i
  end

  def replays_list!
    hsreplay_ids = ReplayOutcome.where(id: replay_outcome_ids)
      .order('created_at DESC')
      .pluck(:hsreplay_id)
    hsreplay_ids.map do |hsreplay_id|
      begin
        replay_data = ReplayDataCache.new.replay_data_hash(hsreplay_id)
        errors = false
        if replay_data.dig(:p1, :legend_rank).nil? and
           replay_data.dig(:p2, :legend_rank).nil?
          logger.info "#{hsreplay_id} legend ranks are both nil"
          errors = true
        end
        if replay_data[:deck_card_names].length == 0
          logger.info "#{hsreplay_id} is missing a deck"
        end
        if errors
          nil
        else
          replay_data
        end
      rescue => e
        logger.error "json_response! - replay #{hsreplay_id}"
        logger.error "#{e.class.name}: #{e.message}"
        logger.error "#{e.backtrace.join("\n")}"
        nil
      end
    end.compact
  end

  def replays_list
    return @replays_list if defined? @replays_list
    @replays_list = replays_list!
  end

  def to_hash
    {
      path: @path,
      rank: @rank,
      region: @region,
      page: @page,
      route: route,
      page_size: ReplayOutcomeQuery::PAGE_SIZE,
      replays_count: replays_list.length,
      replays: replays_list,
    }
  end

  def to_json
    to_hash.to_json
  end

  def cache_key
    "replay_outcomes:json_responses:#{@path}:#{@rank}:#{@region}:page=#{@page}"
  end

  private

  def replay_outcome_ids
    class_query = route || { class: 'any', archetype: 'any' }
    ReplayOutcomeCache.new.replay_outcome_ids(class_query, {
      rank: @rank,
      region: @region,
      page: @page
    })
  end

  def route
    @route ||= RouteMap.new.lookup(@path)
  end

  def get_page(page)
    return 1 if page < 1
    return PAGE_LIMIT if page > PAGE_LIMIT
    page
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/replay_json.log")
  end
end
