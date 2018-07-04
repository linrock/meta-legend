class ReplayStats

  # min number of games for an archetype to be considered
  MIN_GAMES = 0

  def initialize(replay_outcomes)
    @replay_outcomes = replay_outcomes
  end

  # arch_id -> { wins, losses }
  def archetype_wins_and_losses
    stats = Hash[Archetype.all.map {|arch| [arch.data["id"], { wins: 0, losses: 0 }] }]
    @replay_outcomes.each do |outcome|
      p1_arch_id = outcome.data["player1_archetype"].to_i
      p2_arch_id = outcome.data["player2_archetype"].to_i
      if stats[p1_arch_id].nil? || stats[p2_arch_id].nil?
        logger.error "wins_and_losses - replay #{outcome.id} (#{p1_arch_id} vs #{p2_arch_id})"
        next
      end
      if outcome.player1_won?
        stats[p1_arch_id][:wins] += 1
        stats[p2_arch_id][:losses] += 1
      else
        stats[p1_arch_id][:losses] += 1
        stats[p2_arch_id][:wins] += 1
      end
    end
    stats.select do |_, counts|
      counts[:wins] + counts[:losses] > MIN_GAMES
    end
  end

  # path -> { wins, losses }
  def wins_and_losses
    class_stats = Hash[PlayerClass::NAMES.map {|name| [name.downcase, { wins: 0, losses: 0 }] }]
    archetype_stats = {}
    archetype_wins_and_losses.each do |arch_id, counts|
      archetype = Archetype.find_by_archetype_id arch_id
      class_stats[archetype.class_name.downcase][:wins] += counts[:wins]
      class_stats[archetype.class_name.downcase][:losses] += counts[:losses]
      archetype_stats[archetype.path] = counts
    end
    class_stats.merge(archetype_stats)
  end

  def winrates
    winrate_stats = wins_and_losses
    winrate_stats.each do |path, stats|
      n_games = stats[:wins] + stats[:losses]
      winrate = 100.0 * stats[:wins] / n_games
      winrate_stats[path] = {
        n: n_games,
        winrate: "%0.1f" % winrate
      }
    end
    winrate_stats
  end

  def to_route_map
    winrate_stats = winrates
    winrate_stats.each do |path, stats|
      winrate_stats[path].merge!(route_map.lookup(path))
    end
    winrate_stats
  end

  # Counts the number of games played by each archetype
  def archetype_counts
    counts = {}
    ids = @replay_outcomes.map(&:archetype_ids).flatten
    ids.each do |arch_id|
      counts[arch_id] ||= 0
      counts[arch_id] += 1
    end
    total_n_games = @replay_outcomes.length
    counts.sort_by {|id, n_games| -n_games }.take(3).map do |id, n_games|
      archetype = Archetype.find_by_archetype_id id
      {
        name: archetype.name,
        path: archetype.path,
        n_games: n_games,
        percent_games: "%0.2f" % (n_games * 100.0 / total_n_games),
      }
    end
  end

  # Counts the number of games found for each player
  def most_active_players
    ReplayXmlData
      .where(hsreplay_id: @replay_outcomes.pluck(:hsreplay_id))
      .pluck(:extracted_data).compact.map do |data|
      data ? data['p1']['tag'] : nil
    end.compact.flatten.group_by(&:to_s).map do |k,v|
      [k, v.length ]
    end.sort_by {|_, v| -v }.take(5)
  end

  # counts the number of games submitted via webhooks
  def top_webhook_submitters
    names = WebhookBlob.select(&:valid?).map { |blob| blob.p1_name }
    names.group_by(&:to_s).map {|k,v| [k,v.length] }.sort_by {|_, v| -v }
  end

  # counts the number of games submitted via the user form
  def top_form_submitters
    battletags = UserSubmittedReplay.all.map {|r| r.user.battletag }
    battletags.group_by(&:to_s).map {|k,v| [k,v.length] }.sort_by {|_, v| -v }
  end

  def replays_count
    count = @replay_outcomes.count
    count.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def oldest_replay_timestamp
    @replay_outcomes.order("created_at DESC").last&.created_at
  end

  private

  def route_map
    @route_map ||= RouteMap.new
  end

  def logger
    @logger ||= Logger.new "#{Rails.root}/log/replay_stats.log"
  end
end
