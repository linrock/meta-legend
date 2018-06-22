# for busting the homepage cache

class CacheBuster
  def initialize
    ReplayOutcomeCache.new.replay_outcome_ids!({
      class: 'any',
      archetype: 'any'
    }, {
      page: 1
    })
    JsonResponseCache.new.json_response!
  end
end
