class DecksController < ApplicationController

  def index
    @filter = get_filter(request.path)
    cache = ReplayStatsCache.new.legend_stats @filter
    stats = cache[:routes].map {|path, route| route.merge({ path: path }) }
    classes = stats.select {|s| !s[:archetype] }.sort_by {|s| -s[:winrate].to_f }
    archetype_stats = classes.map do |class_stats|
      stats.select do |s|
        s[:archetype].present? and s[:class] == class_stats[:class]
      end.sort_by {|s| -s[:n].to_f }
    end
    @class_stats = classes.zip(archetype_stats)
    @count = cache[:about][:count]
    @days = ((Time.now - cache[:about][:since]) / 86400).round
    @title = "Decks | Meta Legend"
    @meta_desc = "Top decks and statistics of #{get_player_desc(request.path)} Hearthstone players over the past #{@days} days. Learn from how the top players play."
  end

  private

  def get_filter(path)
    if path =~ /top-1000/
      "top-1000"
    elsif path =~ /top-500/
      "top-500"
    elsif path =~ /top-100/
      "top-100"
    end
  end

  def get_player_desc(path)
    if path =~ /top-1000/
      "the top 1000"
    elsif path =~ /top-500/
      "the top 500"
    elsif path =~ /top-100/
      "the top 100"
    else
      "legend-rank"
    end
  end
end
