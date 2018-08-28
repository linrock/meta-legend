class WildController < ApplicationController
  PAGE_SIZE = 25

  def index
    title_and_description = TitleAndDescription.new(params)
    @title = title_and_description.html_title
    @meta_desc = title_and_description.html_meta_description
  end

  def replays
    render json: replay_data_json(params[:page].to_i)
  end

  private

  def replay_data_json(page = 1)
    page = 1 if page < 1
    hsreplay_ids = ReplayGameApiResponse.wild
      .offset((page - 1) * PAGE_SIZE)
      .limit(PAGE_SIZE).pluck(Arel.sql("data -> 'shortid'"))
    replays = hsreplay_ids.map do |hsreplay_id|
      ReplayDataCache.new.replay_data_hash(hsreplay_id) rescue nil
    end.compact
    {
      page: page,
      path: '/',
      replays_count: replays.length,
      replays: replays,
    }.to_json
  end
end
