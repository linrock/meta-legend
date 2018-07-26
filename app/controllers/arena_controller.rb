class ArenaController < ApplicationController

  def index
    hsreplay_ids = ReplayGameApiResponse.arena.pluck(
      Arel.sql("data -> 'shortid'")
    )
    replays = hsreplay_ids.map do |hsreplay_id|
      ReplayDataCache.new.replay_data_hash(hsreplay_id) rescue nil
    end.compact
    @replay_data = {
      replays_count: replays.length,
      replays: replays,
    }.to_json
    title_and_description = TitleAndDescription.new(params)
    @title = title_and_description.html_title
    @meta_desc = title_and_description.html_meta_description
  end
end
