class ReplayStats

  # min number of games for an archetype to be considered
  MIN_GAMES = 50

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
      winrate = 100.0 * stats[:wins] / (stats[:wins] + stats[:losses])
      stats[:winrate] = "%0.1f" % winrate
      stats.delete(:wins)
      stats.delete(:losses)
      winrate_stats[path] = stats
    end
    winrate_stats
  end

  def to_path_map
    path_map = ArchetypeCache.new.path_map
    winrate_stats = winrates
    winrate_stats.each do |path, stats|
      winrate_stats[path].merge!(path_map[path])
    end
    winrate_stats
  end

  def replays_count
    count = @replay_outcomes.count
    count.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def oldest_replay_timestamp
    @replay_outcomes.order("created_at ASC").first.created_at
  end

  private

  def logger
    @logger ||= Logger.new "#{Rails.root}/log/error.log"
  end
end
