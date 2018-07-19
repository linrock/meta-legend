# imports data from the game api endpoint - /api/v1/games/:hsreplay_id
require 'open-uri'

class ReplayGameApiResponseImporter
  API_BASE_URL = "https://hsreplay.net/api/v1/games/"

  def initialize(hsreplay_id)
    @hsreplay_id = hsreplay_id
  end

  def url
    "#{API_BASE_URL}#{@hsreplay_id}/?format=json"
  end

  def json_data
    @json_data ||= JSON.parse(open(url).read)
  end

  def import
    return if replay_game_api_response.present?
    import!
  end

  def import!
    if replay_game_api_response
      replay_game_api_response.data = json_data
      replay_game_api_response.save!
    else
      ReplayGameApiResponse.create!({
        hsreplay_id: @hsreplay_id,
        data: json_data
      })
    end
  end

  private

  def replay_game_api_response
    @replay_game_api_response ||= ReplayGameApiResponse.find_by(hsreplay_id: @hsreplay_id)
  end
end
