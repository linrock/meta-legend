class DecksController < ApplicationController

  def index
    cache = ReplayStatsCache.new.legend_stats
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
    @meta_desc = "Top decks and statistics of legend Hearthstone players over the past #{@days} days. Learn from the top players."
  end
end
