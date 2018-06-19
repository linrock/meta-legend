class ReplayJson

  def initialize(hsreplay_id)
    @hsreplay_id = hsreplay_id
  end

  def to_hash
    begin
      replay_data = ReplayDataCache.new.replay_data_hash(@hsreplay_id)
      errors = false
      if replay_data.dig(:p1, :legend_rank).nil? and
         replay_data.dig(:p2, :legend_rank).nil?
        logger.info "#{@hsreplay_id} legend ranks are both nil"
        errors = true
      end
      if replay_data[:deck_card_names].length == 0
        logger.info "#{@hsreplay_id} is missing a deck"
      end
      if errors
        nil
      else
        replay_data
      end
    rescue => e
      logger.error "#{@hsreplay_id} - error in #to_hash"
      logger.error "#{e.class.name}: #{e.message}"
      logger.error "#{e.backtrace.join("\n")}"
      nil
    end
  end

  private

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/replay_json.log")
  end
end
