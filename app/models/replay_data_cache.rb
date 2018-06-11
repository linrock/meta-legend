class ReplayDataCache

  def self.refresh_recent!
    cache = self.new
    ReplayOutcome.order('created_at DESC').limit(1000).pluck(:hsreplay_id).each do |id|
      cache.replay_data_hash!(id) rescue nil
    end
  end

  def initialize
    @cache = Rails.cache
  end

  def replay_data_hash(hsreplay_id)
    results = @cache.read replay_data_hash_cache_key(hsreplay_id)
    return results if results.present?
    replay_data_hash! hsreplay_id
  end

  def replay_data_hash!(hsreplay_id)
    results = ReplayData.new(hsreplay_id).to_hash
    @cache.write replay_data_hash_cache_key(hsreplay_id), results
    results
  end

  private

  def replay_data_hash_cache_key(hsreplay_id)
    "replay_data:#{hsreplay_id}:hash"
  end
end
