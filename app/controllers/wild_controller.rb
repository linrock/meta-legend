class WildController < ApplicationController

  def index
    @replay_data = JsonResponseCache.new(params).cached_json_response || "{}"
    title_and_description = TitleAndDescription.new(params)
    @title = title_and_description.html_title
    @meta_desc = title_and_description.html_meta_description
  end
end
